import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:jpush_flutter/jpush_flutter.dart';
import 'package:punchcardclient/common/funs.dart';
import 'package:punchcardclient/common/global.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
//  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;

    try {
      jpush.addEventHandler(
          onReceiveNotification: (Map<String, dynamic> message) async {
        print("flutter onReceiveNotification: $message");
        setState(() {
          debugLable = "flutter onReceiveNotification: $message";
        });
      }, onOpenNotification: (Map<String, dynamic> message) async {
        print("flutter onOpenNotification: $message");
        setState(() {
          debugLable = "flutter onOpenNotification: $message";
        });
      }, onReceiveMessage: (Map<String, dynamic> message) async {
        print("flutter onReceiveMessage: $message");
        setState(() {
          debugLable = "flutter onReceiveMessage: $message";
        });
      }, onReceiveNotificationAuthorization:
              (Map<String, dynamic> message) async {
        print("flutter onReceiveNotificationAuthorization: $message");
        setState(() {
          debugLable = "flutter onReceiveNotificationAuthorization: $message";
        });
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    jpush.setup(
      appKey: "e58a32cb3e4469ebf31867e5", //你自己应用的 AppKey
      channel: "theChannel",
      production: false,
      debug: true,
    );
    jpush.applyPushAuthority(
        new NotificationSettingsIOS(sound: true, alert: true, badge: true));

    // Platform messages may fail, so we use a try/catch PlatformException.
    jpush.getRegistrationID().then((rid) {
      print("flutter get registration id : $rid");
      setState(() {
        debugLable = "flutter getRegistrationID: $rid";
      });
    });

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      debugLable = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
//    /// 动态申请定位权限
//    _locationPlugin.requestPermission();

    return Scaffold(
      appBar: AppBar(
        title: Text('打卡客户端'),
        leading: new Icon(Icons.home),
        actions: <Widget>[
          // 非隐藏的菜单
          new IconButton(
              icon: new Icon(Icons.exit_to_app),
              tooltip: '退出',
              onPressed: () {
                Global.saveSP("url", "");
                Navigator.of(context).pop();
                Navigator.pushNamed(context, "login");
              }),
        ],
      ),
      body: Center(
          child: GridView.count(
        crossAxisCount: 3,
        childAspectRatio: 1.0,
        //水平子Widget之间间距
        crossAxisSpacing: 10.0,
        //垂直子Widget之间间距
        mainAxisSpacing: 10.0,
        //GridView内边距
        padding: EdgeInsets.all(10.0),
        children: <Widget>[
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "点击打卡",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              showToast("课程表");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "查看计划",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "plan_list");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "查看项目",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              showToast("查看项目");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "课程表",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              _simpleDialog();
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "作息表",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "schedule_list");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "校历",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "calendar_list");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "查看考勤",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              Navigator.pushNamed(context, "sign_list");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "查看假条",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
//              showToast("查看假条");
              Navigator.pushNamed(context, "vacate_list");
            },
          ),
        ],
      )), // 构建主页面
    );
  }

  _simpleDialog() async {
    var result = await showDialog(
        context: context,
        builder: (context) {
          return SimpleDialog(
            title: Text('选择内容'),
            children: <Widget>[
              SimpleDialogOption(
                child: Text('Option A'),
                onPressed: () {
                  print('Option A');
                  Navigator.pop(context, 'A');
                  _modelBottomSheet();
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('Option B'),
                onPressed: () {
                  print('Option B');
                  Navigator.pop(context, 'B');
                  _alertDialog();
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('Option C'),
                onPressed: () {
                  print('Option C');
                  Navigator.pop(context, 'C');
                },
              ),
              Divider(),
            ],
          );
        });

    showToast(result);
  }

  _alertDialog() async {
    var result = await showDialog(
        //通过异步在外面获取值
        context: context,
        builder: (context) {
          return AlertDialog(
            //系统自带： 普通对话框
            title: Text('提示信息！'),
            content: Text('您确定要删除吗？'),
            actions: <Widget>[
              //监听器
              FlatButton(
                //确定监听
                child: Text('取消'),
                onPressed: () {
                  print('取消');
                  Navigator.pop(context, 'Cancle');
                },
              ),
              FlatButton(
                //取消监听
                child: Text('确定'),
                onPressed: () {
                  print('确定');
                  Navigator.pop(context, 'OK');
                },
              )
            ],
          );
        });

    showToast(result); //在外部获取数据并打印
  }

  _modelBottomSheet() async {
    var result = await showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
            height: 250, //配置底部弹出框高度
            child: Column(
              children: <Widget>[
                ListTile(
                  title: Text('分享 A'),
                  onTap: () {
                    Navigator.pop(context, '分享A');
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('分享 B'),
                  onTap: () {
                    Navigator.pop(context, '分享B');
                  },
                ),
                Divider(),
                ListTile(
                  title: Text('分享 C'),
                  onTap: () {
                    Navigator.pop(context, '分享C');
                  },
                ),
              ],
            ),
          );
        });

    showToast(result);
  }
}
