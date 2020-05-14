import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:punchcardclient/common/global.dart';
import 'package:punchcardclient/other/showcase.dart';
import 'package:punchcardclient/routes/calendar_list.dart';
import 'package:punchcardclient/routes/home.dart';
import 'package:punchcardclient/routes/login.dart';
import 'package:punchcardclient/routes/plan.dart';
import 'package:punchcardclient/routes/plan_list.dart';
import 'package:punchcardclient/routes/schedule_list.dart';
import 'package:punchcardclient/routes/sign_list.dart';
import 'package:punchcardclient/routes/vacate.dart';
import 'package:punchcardclient/routes/vacate_list.dart';

import 'other/image_picker_page.dart';

void main() => Global.init().then((e) => runApp(MyApp()));

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '打卡客户端',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FutureBuilder<String>(
        future: Global.getSP("url"),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          // 请求已结束
          if (snapshot.connectionState == ConnectionState.done) {
            print("snapshot.data=" + snapshot.data.toString());
            if (snapshot.data == null || snapshot.data.toString().isEmpty) {
              return LoginPage(title: '登录');
            } else {
              return HomeRoute();
            }
          } else {
            return Image(
              image: AssetImage("imgs/timg.jpg"),
              fit: BoxFit.fill,
            );
          }
        },
      ),
      // 注册路由表
      routes: <String, WidgetBuilder>{
        "login": (context) => LoginPage(),
        "home": (context) => HomeRoute(),
        "plan_list": (context) => PlanListRoute(),
        "plan": (context) => PlanRoute(),
        "sign_list": (context) => SignListRoute(),
        "vacate_list": (context) => VacateListRoute(),
        "vacate": (context) => VacateRoute(),
        "calendar_list": (context) => CalendarListRoute(),
        "schedule_list": (context) => ScheduleListRoute(),
        "show_case": (context) => ShowCaseRoute(),
        "image_picker": (context) => ImagePickerPage(),
      },
      localizationsDelegates: [
        // 本地化的代理类
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: [
        //此处
        const Locale('zh', 'CH'),
        const Locale('en', 'US'),
      ],
    );
  }
}

class FallbackCupertinoLocalisationsDelegate
    extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
