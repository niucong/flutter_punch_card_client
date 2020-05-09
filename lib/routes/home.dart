import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/funs.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/common/global.dart';

class HomeRoute extends StatefulWidget {
  @override
  _HomeRouteState createState() => _HomeRouteState();
}

class _HomeRouteState extends State<HomeRoute> {
  @override
  Widget build(BuildContext context) {
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
            onPressed: () async {
              await Git(context).getPlanList(
                {
                  'offset': 0,
                  'pageSize': '20',
                },
              );
              showToast("点击打卡");
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
              showToast("课程表");
            },
          ),
          RaisedButton(
            padding: const EdgeInsets.all(15.0),
            child: Text(
              "作息表",
              textScaleFactor: 1.3,
            ),
            onPressed: () {
              showToast("作息表");
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
}
