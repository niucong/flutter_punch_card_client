import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:dio/adapter.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/entity/basic_entity.dart';
import 'package:punchcardclient/entity/calendar_list_entity.dart';
import 'package:punchcardclient/entity/login_entity.dart';
import 'package:punchcardclient/entity/member_list_enity.dart';
import 'package:punchcardclient/entity/plan_list_entity.dart';
import 'package:punchcardclient/entity/sign_list_entity.dart';
import 'package:punchcardclient/entity/vacate_list_entity.dart';

import 'global.dart';

class Git {
  // 在网络请求过程中可能会需要使用当前的context信息，比如在请求失败时
  // 打开一个新路由，而打开新路由需要context信息。
  Git([this.context]) {
    _options = Options(extra: {"context": context});
  }

  BuildContext context;
  Options _options;
  static var userId = 0;
  static Dio dio = new Dio(BaseOptions(
//    baseUrl: //"http://192.168.1.102:8080/",
//        getSP("url").toString(),
//    headers: {
////      HttpHeaders.acceptHeader: "application/vnd.github.squirrel-girl-preview,"
////          "application/vnd.github.symmetra-preview+json",
//      'Content-Type': 'application/x-www-form-urlencoded',
//      "userId":4,
//    },
//    headers: httpHeaders,
      ));

  static void init() {
    // 添加缓存插件
//    dio.interceptors.add(Global.netCache);
    // 设置用户token（可能为null，代表未登录）
//    dio.options.headers[HttpHeaders.authorizationHeader] = Global.profile.token;
    dio.options.headers[HttpHeaders.contentTypeHeader] =
        "application/x-www-form-urlencoded";
//    dio.options.headers.addAll(httpHeaders);

    //application/x-www-form-urlencoded
  }

  // 登录接口，登录成功后返回用户信息
  Future<LoginEntity> login(Map params) async {
    String url = await Global.getSP("url");
    print(url + "login");
    print(params);
    var r = await dio.post(
      url + "login",
      data: params,
    );
    print("data:" + r.data);
    LoginEntity loginEntity = LoginEntity.fromJson(json.decode(r.data));
    return loginEntity;
  }

  // 获取考勤列表
  Future<SignListEntity> getSignList(Map params) async {
    String url = await Global.getSP("url");
    print(url + "signList");
    print(params);
    userId = await Global.getSPInt("userId");

    var r = await dio.post(
      url + "signList",
      data: params,
      options: _options.merge(
        headers: httpHeaders,
      ),
    );
    print(r);
    return SignListEntity.fromJson(json.decode(r.data));
  }

  //获取成员列表
  Future<MemberListEntity> getMemberList(Map params) async {
//    setProxy();
    String url = await Global.getSP("url");
    print(url + "memberList");
    print(params);
    userId = await Global.getSPInt("userId");
    print("userId:" + userId.toString());
    var r = await dio.post(
      url + "memberList",
      data: params,
      options: _options.merge(
        headers: httpHeaders,
      ),
    );
    print(r);
    return MemberListEntity.fromJson(json.decode(r.data));
  }

  //获取计划列表
  Future<PlanListEntity> getPlanList(Map params) async {
//    setProxy();
    String url = await Global.getSP("url");
    print(url + "planList");
    print(params);
    userId = await Global.getSPInt("userId");
    print("userId:" + userId.toString());
    var r = await dio.post(
      url + "planList",
      data: params,
      options: _options.merge(
        headers: httpHeaders,
      ),
    );
    print(r);
    return PlanListEntity.fromJson(json.decode(r.data));
  }

  //请假
  Future<BasicEntity> vacate(Map params) async {
//    setProxy();
    String url = await Global.getSP("url");
    print(url + "vacate");
    print(params);
    userId = await Global.getSPInt("userId");
    print("userId:" + userId.toString());
    var r = await dio.post(
      url + "vacate",
      data: params,
      options: _options.merge(
        headers: httpHeaders,
      ),
    );
    print(r);
    return BasicEntity.fromJson(json.decode(r.data));
  }

  //获取请假列表
  Future<VacateListEntity> getVacateList(Map params) async {
//    setProxy();
    String url = await Global.getSP("url");
    print(url + "vacateList");
    print(params);
    userId = await Global.getSPInt("userId");
    print("userId:" + userId.toString());
    var r = await dio.post(
      url + "vacateList",
      data: params,
      options: _options.merge(
        headers: httpHeaders,
      ),
    );
    print(r);
    return VacateListEntity.fromJson(json.decode(r.data));
  }

  //获取校历
  Future<CalendarListEntity> getCalendarList(Map params) async {
//    setProxy();
    String url = await Global.getSP("url");
    print(url + "calendarList");
    print(params);
    userId = await Global.getSPInt("userId");
    print("userId:" + userId.toString());
    var r = await dio.post(
      url + "calendarList",
      data: params,
      options: _options.merge(
        headers: httpHeaders,
      ),
    );
    print(r);
    return CalendarListEntity.fromJson(json.decode(r.data));
  }

  /// 自定义Header
  static Map<String, dynamic> httpHeaders = {
    'Content-Type': 'application/x-www-form-urlencoded',
    'User-Agent': 'okhttp/3.11.0',
    'userId': userId,
  };

  void setProxy() {
    //     设置代理抓包
    (dio.httpClientAdapter as DefaultHttpClientAdapter).onHttpClientCreate =
        (client) {
      client.badCertificateCallback =
          (X509Certificate cert, String host, int port) {
        return Platform.isAndroid;
      };
      client.findProxy = (url) {
        return 'PROXY 192.168.1.109:8888';
      };
    };
  }
}
