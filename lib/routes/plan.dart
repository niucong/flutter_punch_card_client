import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PlanRoute extends StatefulWidget {
  @override
  _PlanRouteState createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计划'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Wrap(
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "计划名称：",
                  textScaleFactor: 1.3,
                ),
                TextFormField(
                  decoration: InputDecoration(
                    hintText: '请输入名称',
                  ),
                ),
              ],
            ),
//            Row(
//              children: <Widget>[
//                Text(
//                  "关联人员：",
//                  textScaleFactor: 1.3,
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Text(
//                  "开始时间：",
//                  textScaleFactor: 1.3,
//                ),
//              ],
//            ),
//            Row(
//              children: <Widget>[
//                Text(
//                  "结束时间：",
//                  textScaleFactor: 1.3,
//                ),
//              ],
//            ),
//            RaisedButton(
//              padding: EdgeInsets.all(10.0),
//              color: Theme.of(context).primaryColor,
//              onPressed: () {},
//              textColor: Colors.white,
//              child: Text('提交'),
//            ),
          ],
        ),
      ),
      // 构建主页面
    );
  }

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

class MyListView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    //下划线widget预定义以供复用。
    Widget divider1 = Divider(
      color: Colors.blue,
    );
    Widget divider2 = Divider(color: Colors.green);
    return ListView.separated(
      itemCount: 100,
      //列表项构造器
      itemBuilder: (BuildContext context, int index) {
        return ListTile(title: Text("$index"));
      },
      //分割器构造器
      separatorBuilder: (BuildContext context, int index) {
        return index % 2 == 0 ? divider1 : divider2;
      },
    );
  }
}
