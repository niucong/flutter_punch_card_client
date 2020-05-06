import 'package:flutter/material.dart';
import 'package:punchcardclient/routes/home.dart';
import 'package:punchcardclient/routes/login.dart';
import 'package:punchcardclient/routes/plan.dart';
import 'package:punchcardclient/routes/plan_list.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'common/funs.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '打卡客户端',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(title: '登录'),
      // 注册路由表
      routes: <String, WidgetBuilder>{
        "login": (context) => LoginPage(),
        "home": (context) => HomeRoute(),
        "plan_list": (context) => PlanListRoute(),
        "plan": (context) => PlanRoute(),
      },
    );
  }
}
