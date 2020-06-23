import 'dart:convert';
import 'dart:io';

import 'package:floor/floor.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/db/database.dart';
import 'package:punchcardclient/entity/schedule_list_entity.dart';

class ScheduleListRoute extends StatefulWidget {
  @override
  _ScheduleListRouteState createState() => _ScheduleListRouteState();
}

class _ScheduleListRouteState extends State<ScheduleListRoute> {
  static const platform =
      const MethodChannel('punchcardclient.niucong.com/native');

  @override
  void initState() {
    super.initState();
    listData.clear();
    _retrieveData();
  }

  void _retrieveData() async {
    final database = await $FloorFlutterDatabase
        .databaseBuilder('database.db')
        .addMigrations(<Migration>[
      Migration(1, 2, (db) {
//         db.execute('ALTER TABLE Work ADD COLUMN create_time TEXT');
        db.execute(
            'CREATE TABLE Schedule(id INTEGER PRIMARY KEY,timeRank TEXT,sectionName TEXT,time TEXT)');
      }),
    ]).build();
    listData.addAll(await database.scheduleDao.findSchedule());
    if (listData.isEmpty) {
      var listEntity = await Git(context).getScheduleList(
        {},
      );
      listData.addAll(listEntity.list);
      for (int i = 0; i < listData.length; i++)
        await database.scheduleDao.insertSchedule(listData[i]);
    }

    print(json.encode(listData));

    if(Platform.isIOS){
      //ios相关代码
      setState(() {});
    } else if(Platform.isAndroid){
      //android相关代码
      await platform.invokeMethod('toScheduleActivity', <String, dynamic>{
        'listData': json.encode(listData),
//      'listData': 'listData',
      });
//    Navigator.pop(context);
//    await platform.invokeMethod('toScheduleActivity');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('作息表'),
        actions: <Widget>[
          // 隐藏的菜单
          new PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.SelectView(Icons.refresh, '刷新', 'B'),
            ],
            onSelected: (String action) {
              // 点击选项的时候
              switch (action) {
                case 'B':
                  break;
              }
            },
          ),
        ],
      ),
      body: Wrap(
        children: <Widget>[
          Container(
            margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "时段",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "节次",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 2,
                  child: Text(
                    "上课时间",
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height - 56 - 56,
            child: ListView.separated(
                shrinkWrap: true,
                itemBuilder: _renderRow,
                physics: AlwaysScrollableScrollPhysics(),
                //设置physics属性总是可滚动
                separatorBuilder: (context, index) => Divider(
                      height: .0,
                    ),
                itemCount: listData.length),
          ),
        ],
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    return ListItemWidget(index, listData[index]);
  }

  final List<Schedule> listData = [];

  // 返回每个隐藏的菜单项
  SelectView(IconData icon, String text, String id) {
    return new PopupMenuItem<String>(
        value: id,
        child: new Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            new Icon(icon, color: Colors.blue),
            new Text(text),
          ],
        ));
  }
}

class ListItemWidget extends StatelessWidget {
  final Schedule listItem;
  final int index;

  ListItemWidget(this.index, this.listItem);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.timeRank,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.sectionName,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 2,
            child: Text(
              listItem.time,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
