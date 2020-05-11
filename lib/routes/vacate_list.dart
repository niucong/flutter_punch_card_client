import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/entity/vacate_list_entity.dart';
import 'package:punchcardclient/routes/vacate.dart';

class VacateListRoute extends StatefulWidget {
  @override
  _VacateListRouteState createState() => _VacateListRouteState();
}

class _VacateListRouteState extends State<VacateListRoute> {
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
      await Git(context).getVacateList(
        {
          'offset': listData.length,
          'pageSize': 5,
        },
      ).then((VacateListEntity signListEntity) {
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
        title: Text('查看假条'),
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
//      body: RefreshIndicator(
//        onRefresh: _onRefresh,
//        child: ListView.builder(
//          itemBuilder: _renderRow,
//          itemCount: listData.length + 1,
//          controller: _scrollController,
//        ),
//      ),

      body: Wrap(
        children: <Widget>[
          Container(
            margin: EdgeInsets.all(15.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '名称',
              ),
            ),
          ),
          RefreshIndicator(
            onRefresh: _onRefresh,
            child: SizedBox(
              height: MediaQuery.of(context).size.height - 56 - 56 - 38,
              child: ListView.builder(
                shrinkWrap: true,
                physics: AlwaysScrollableScrollPhysics(),
                itemBuilder: _renderRow,
                itemCount: listData.length + 1,
                controller: _scrollController,
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

  final List<VacateList> listData = [];
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
  final VacateList listItem;
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
    return InkWell(
      onTap: () async {
        var result = await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return VacateRoute(
                // 路由参数
                listItem: listItem,
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
      child: Column(
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
              listItem.type == 1
                  ? "事假"
                  : listItem.type == 2
                      ? "病假"
                      : listItem.type == 3
                          ? "年假"
                          : listItem.type == 4 ? "调休" : "其它",
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
      ),
    );
  }
}
