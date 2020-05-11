import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/entity/member_list_enity.dart';
import 'package:punchcardclient/entity/plan_list_entity.dart';
import 'package:punchcardclient/routes/plan.dart';

class PlanListRoute extends StatefulWidget {
  @override
  _PlanListRouteState createState() => _PlanListRouteState();
}

class _PlanListRouteState extends State<PlanListRoute> {
  ScrollController _scrollController = ScrollController(); //listview的控制器
  bool isLoading = false; //是否正在加载数据

  @override
  void initState() {
    super.initState();
    _getData();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels ==
          _scrollController.position.maxScrollExtent) {
        print('滑动到了最底部');
        _getData();
      }
    });
  }

  /**
   * 上拉加载更多
   */
  Future _getData() async {
    if (!isLoading) {
      setState(() {
        isLoading = true;
      });
      await Git(context).getPlanList(
        {
          'offset': listData.length,
          'pageSize': 5,
        },
      ).then((PlanListEntity signListEntity) {
        setState(() {
          allSize = signListEntity.allSize;
          print(signListEntity.list.length);
          listData.addAll(signListEntity.list);
          isLoading = false;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计划列表'),
        actions: <Widget>[
          // 隐藏的菜单
          new PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.SelectView(Icons.add, '新建', 'A'),
              this.SelectView(Icons.date_range, '按日期查询', 'B'),
            ],
            onSelected: (String action) async {
              // 点击选项的时候
              switch (action) {
                case 'A':
                  var result = await Navigator.pushNamed(context, "vacate");
                  //输出`TipRoute`路由返回结果
                  print("路由返回值: $result");
                  if (result) {
                    _onRefresh();
                  }
                  break;
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
            margin: EdgeInsets.all(15.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '计划名称',
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: _onRefresh,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 56 - 56 - 38,
              child: ListView.separated(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: _renderRow,
                itemCount: listData.length + 1,
                controller: _scrollController,
                //分割器构造器
                separatorBuilder: (BuildContext context, int index) {
                  return Divider(
                    color: Colors.blue,
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  /**
   * 下拉刷新方法,为list重新赋值
   */
  Future<Null> _onRefresh() async {
    listData.clear();
    _getData();
  }

  /**
   * 加载更多时显示的组件,给用户提示
   */
  Widget _getMoreWidget() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CircularProgressIndicator(
              strokeWidth: 2.0,
            ),
            Container(
              margin: const EdgeInsets.only(left: 10.0),
              child: Text(
                '加载中...',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _renderRow(BuildContext context, int index) {
    if (index < listData.length) {
      return ListItemWidget(index, listData[index]);
    } else if (index == allSize) {
      return Container(
        alignment: Alignment.center,
        padding: EdgeInsets.all(16),
        child: Text('没有更多了', style: TextStyle(color: Colors.pink)),
      );
    }
    return _getMoreWidget();
  }

  final List<PlanList> listData = [];
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
  final PlanList listItem;
  final int index;

  ListItemWidget(this.index, this.listItem);

  @override
  Widget build(BuildContext context) {
    print(listItem.startTime);

    // [{\"id\":3,\"name\":\"张帆\"},{\"id\":1,\"name\":\"主任\"}]
    var members = "";
    List jsons = json.decode(listItem.members);
    List<MemberEntity> memberList =
        jsons.map((m) => new MemberEntity.fromJson(m)).toList();
    for (int i = 0; i < memberList.length; i++) {
      members += "，" + memberList[i].name;
    }
    if (members.isNotEmpty) {
      members = members.substring(1);
    }
    return InkWell(
      onTap: () async {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return PlanRoute(
                  // 路由参数
//                listItem: listItem,
                  );
            },
          ),
        );
        //输出`TipRoute`路由返回结果
        print("路由返回值: $result");
//        if (result) {
//          _onRefresh();
//        }
      },
      child: Container(
        margin: EdgeInsets.all(10),
        child: Wrap(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Text(
                    (index + 1).toString(),
                    textScaleFactor: 1.3,
                  ),
                ),
                Expanded(
                  flex: 0,
                  child: Container(
                    margin: EdgeInsets.only(left: 10),
                    child: Text(
                      listItem.name,
                      textScaleFactor: 1.3,
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "已结束",
                    textScaleFactor: 1.3,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 5, bottom: 5),
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Text(
                      listItem.creatorName,
                      textScaleFactor: 1.3,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Text(
                      DateTime.fromMillisecondsSinceEpoch(listItem.createTime)
                          .toLocal()
                          .toString()
                          .substring(0, 16),
                      textAlign: TextAlign.right,
                      textScaleFactor: 1.3,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              margin: EdgeInsets.only(bottom: 5),
              child: Text(
                '关联人员: $members',
                textScaleFactor: 1.3,
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Text(
                    "起：" +
                        DateTime.fromMillisecondsSinceEpoch(listItem.startTime)
                            .toLocal()
                            .toString()
                            .substring(0, 16),
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.left,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Text(
                    "止：" +
                        DateTime.fromMillisecondsSinceEpoch(listItem.endTime)
                            .toLocal()
                            .toString()
                            .substring(0, 16),
                    textScaleFactor: 1.2,
                    textAlign: TextAlign.right,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
