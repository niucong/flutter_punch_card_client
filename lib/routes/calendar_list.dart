import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/db/database.dart';
import 'package:punchcardclient/entity/calendar_list_entity.dart';

class CalendarListRoute extends StatefulWidget {
  @override
  _CalendarListRouteState createState() => _CalendarListRouteState();
}

class _CalendarListRouteState extends State<CalendarListRoute> {
  static const platform =
      const MethodChannel('punchcardclient.niucong.com/native');

  @override
  void initState() {
    super.initState();
    listData.clear();
    _retrieveData();
  }

  void _retrieveData() async {
    final database =
        await $FloorFlutterDatabase.databaseBuilder('database.db').build();
    listData.addAll(await database.calendarDao.findCalendar());
    if (listData.isEmpty) {
      var listEntity = await Git(context).getCalendarList(
        {},
      );
      listData.addAll(listEntity.list);
      for (int i = 0; i < listData.length; i++)
        await database.calendarDao.insertCalendar(listData[i]);
    }

    Navigator.pop(context);
    await platform.invokeMethod('toCalendarActivity');

//    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('校历'),
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
                  flex: 3,
                  child: Text(
                    "学期",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "周",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 2,
                  child: Text(
                    "月份",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "一",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "二",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "三",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "四",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "五",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "六",
                    textAlign: TextAlign.center,
                  ),
                ),
                Expanded(
                  // flex设置权重
                  flex: 1,
                  child: Text(
                    "日",
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

  final List<Calendar> listData = [];

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
  final Calendar listItem;
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
            flex: 3,
            child: Text(
              listItem.session,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.weekly,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 2,
            child: Text(
              listItem.month,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.monday,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.tuesday,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.wednesday,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.thursday,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.friday,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.saturday,
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            // flex设置权重
            flex: 1,
            child: Text(
              listItem.sunday,
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
