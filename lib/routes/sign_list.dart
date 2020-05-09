import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/entity/sign_list_entity.dart';

class SignListRoute extends StatefulWidget {
  @override
  _SignListRouteState createState() => _SignListRouteState();
}

class _SignListRouteState extends State<SignListRoute> {
  @override
  void initState() {
    super.initState();
    listData.clear();
    _retrieveData();
  }

  void _retrieveData() {
    Git(context).getSignList(
      {
        'offset': listData.length,
        'pageSize': 10,
      },
    ).then((SignListEntity signListEntity) {
      setState(() {
        allSize = signListEntity.allSize;
        print(signListEntity.list.length);
        listData.addAll(signListEntity.list);
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('考勤管理'),
        actions: <Widget>[
          // 隐藏的菜单
          new PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.SelectView(Icons.date_range, '按日期查询', 'B'),
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
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '名称',
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Expanded(
                // flex设置权重
                flex: 2,
                child: Text(
                  '序号',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                // flex设置权重
                flex: 2,
                child: Text(
                  '姓名',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                // flex设置权重
                flex: 5,
                child: Text(
                  '到来时间',
                  textAlign: TextAlign.center,
                ),
              ),
              Expanded(
                // flex设置权重
                flex: 5,
                child: Text(
                  '离开时间',
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
          ListView.separated(
              shrinkWrap: true,
              itemBuilder: _renderRow,
              physics: AlwaysScrollableScrollPhysics(),
              //设置physics属性总是可滚动
              separatorBuilder: (context, index) => Divider(
                    height: .0,
                  ),
              itemCount: listData.length + 1),
        ],
      ), // 构建主页面
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (listData.length == 0) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Text('没有数据', style: TextStyle(color: Colors.pink)),
      );
    } else if (listData.length < allSize) {
      //获取数据
//      _retrieveData();
      //加载时显示loading
      return Container(
        padding: const EdgeInsets.all(16),
        alignment: Alignment.center,
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2,
          ),
        ),
      );
    } else if (index == allSize) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Text('没有更多了', style: TextStyle(color: Colors.pink)),
      );
    } else {
      return ListItemWidget(index, listData[index]);
    }
  }

  final List<SignList> listData = [];
  var allSize;

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
  final SignList listItem;
  final int index;

  ListItemWidget(this.index, this.listItem);

  @override
  Widget build(BuildContext context) {
    print(listItem.startTime);
    var time = "";
    if (listItem.endTime > 0) {
      time = DateTime.fromMillisecondsSinceEpoch(listItem.endTime)
          .toLocal()
          .toString()
          .substring(0, 16);
    }
//    return Container(
//      margin: EdgeInsets.only(top: 10.0, bottom: 10.0),
//      child: Row(
//        mainAxisAlignment: MainAxisAlignment.start,
//        children: <Widget>[
//          Expanded(
//            // flex设置权重
//            flex: 2,
//            child: Text(
//              (index + 1).toString(),
//              textAlign: TextAlign.center,
//            ),
//          ),
//          Expanded(
//            // flex设置权重
//            flex: 2,
//            child: Text(
//              listItem.name,
//              textAlign: TextAlign.center,
//            ),
//          ),
//          Expanded(
//            // flex设置权重
//            flex: 5,
//            child: Text(
//              DateTime.fromMillisecondsSinceEpoch(listItem.startTime)
//                  .toLocal()
//                  .toString()
//                  .substring(0, 16),
//              textAlign: TextAlign.center,
//            ),
//          ),
//          Expanded(
//            // flex设置权重
//            flex: 5,
//            child: Text(
//              time,
//              textAlign: TextAlign.center,
//            ),
//          ),
//        ],
//      ),
//    );
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            (index + 1).toString(),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            listItem.name,
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            DateTime.fromMillisecondsSinceEpoch(listItem.startTime)
                .toLocal()
                .toString()
                .substring(0, 16),
            textAlign: TextAlign.center,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0, bottom: 10.0),
          child: Text(
            time,
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }
}
