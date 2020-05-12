import 'dart:async';

import 'package:bdmap_location_flutter_plugin/bdmap_location_flutter_plugin.dart';
import 'package:bdmap_location_flutter_plugin/flutter_baidu_location.dart';
import 'package:bdmap_location_flutter_plugin/flutter_baidu_location_android_option.dart';
import 'package:bdmap_location_flutter_plugin/flutter_baidu_location_ios_option.dart';
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
  // 百度定位
  Map<String, Object> _loationResult;
  BaiduLocation _baiduLocation;
  StreamSubscription<Map<String, Object>> _locationListener;
  LocationFlutterPlugin _locationPlugin = new LocationFlutterPlugin();

  // 极光推送
  String debugLable = 'Unknown';
  final JPush jpush = new JPush();

  @override
  void initState() {
    super.initState();
    initPlatformState();

    /// 动态申请定位权限
    _locationPlugin.requestPermission();

    /// 设置ios端ak, android端ak可以直接在清单文件中配置
//    LocationFlutterPlugin.setApiKey("百度地图开放平台申请的ios端ak");

    _locationListener =
        _locationPlugin.onResultCallback().listen((Map<String, Object> result) {
      setState(() {
        _loationResult = result;
        try {
          _baiduLocation = BaiduLocation.fromMap(result);
//          print(_baiduLocation);
        } catch (e) {
          print(e);
        }
      });
    });
  }

  @override
  void dispose() {
    super.dispose();
    if (null != _locationListener) {
      _locationListener.cancel();
    }
  }

  /// 设置android端和ios端定位参数
  void _setLocOption() {
    /// android 端设置定位参数
    BaiduLocationAndroidOption androidOption = new BaiduLocationAndroidOption();
    androidOption.setCoorType("bd09ll"); // 设置返回的位置坐标系类型
    androidOption.setIsNeedAltitude(true); // 设置是否需要返回海拔高度信息
    androidOption.setIsNeedAddres(true); // 设置是否需要返回地址信息
    androidOption.setIsNeedLocationPoiList(true); // 设置是否需要返回周边poi信息
    androidOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    androidOption.setIsNeedLocationDescribe(true); // 设置是否需要返回位置描述
    androidOption.setOpenGps(true); // 设置是否需要使用gps
    androidOption.setLocationMode(LocationMode.Hight_Accuracy); // 设置定位模式
    androidOption.setScanspan(1000); // 设置发起定位请求时间间隔

    Map androidMap = androidOption.getMap();

    /// ios 端设置定位参数
    BaiduLocationIOSOption iosOption = new BaiduLocationIOSOption();
    iosOption.setIsNeedNewVersionRgc(true); // 设置是否需要返回最新版本rgc信息
    iosOption.setBMKLocationCoordinateType(
        "BMKLocationCoordinateTypeBMK09LL"); // 设置返回的位置坐标系类型
    iosOption.setActivityType("CLActivityTypeAutomotiveNavigation"); // 设置应用位置类型
    iosOption.setLocationTimeout(10); // 设置位置获取超时时间
    iosOption.setDesiredAccuracy("kCLLocationAccuracyBest"); // 设置预期精度参数
    iosOption.setReGeocodeTimeout(10); // 设置获取地址信息超时时间
    iosOption.setDistanceFilter(100); // 设置定位最小更新距离
    iosOption.setAllowsBackgroundLocationUpdates(true); // 是否允许后台定位
    iosOption.setPauseLocUpdateAutomatically(true); //  定位是否会被系统自动暂停

    Map iosMap = iosOption.getMap();

    _locationPlugin.prepareLoc(androidMap, iosMap);
  }

  /// 启动定位
  void _startLocation() {
    if (null != _locationPlugin) {
      _setLocOption();
      _locationPlugin.startLocation();
    }
  }

  /// 停止定位
  void _stopLocation() {
    if (null != _locationPlugin) {
      _locationPlugin.stopLocation();
    }
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
    if (_loationResult != null) {
      _loationResult.forEach((key, value) {
        print("key:$key");
        print("value:$value");
        showToast("定位成功");
        _stopLocation();
      });
    }

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
                child: Text('开始定位'),
                onPressed: () {
                  print('开始定位');
                  Navigator.pop(context, '开始定位');
                  _startLocation();
                },
              ),
              Divider(),
              SimpleDialogOption(
                child: Text('停止定位'),
                onPressed: () {
                  print('停止定位');
                  Navigator.pop(context, '停止定位');
                  _stopLocation();
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
