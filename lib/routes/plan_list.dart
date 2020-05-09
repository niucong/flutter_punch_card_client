import 'package:flukit/flukit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/entity/plan_list_entity.dart';
import 'package:punchcardclient/widgets/repo_item.dart';

class PlanListRoute extends StatefulWidget {
  @override
  _PlanListRouteState createState() => _PlanListRouteState();
}

class _PlanListRouteState extends State<PlanListRoute> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计划列表'),
        actions: <Widget>[
          // 隐藏的菜单
          new PopupMenuButton<String>(
            itemBuilder: (BuildContext context) => <PopupMenuItem<String>>[
              this.SelectView(Icons.add, '新建计划', 'A'),
              this.SelectView(Icons.date_range, '按日期查询', 'B'),
            ],
            onSelected: (String action) {
              // 点击选项的时候
              switch (action) {
                case 'A':
                  Navigator.pushNamed(context, "plan");
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
          Padding(
            padding: EdgeInsets.all(15.0),
            child: TextFormField(
              decoration: InputDecoration(
                hintText: '计划名称',
              ),
            ),
          ),
//          InfiniteListView<PlanList>(
//            onRetrieveData:
//                (int page, List<PlanList> items, bool refresh) async {
//              print(page.toString() + "   " + refresh.toString());
//              var data = await Git(context).getPlanList(
//                {
//                  'offset': 0,//refresh ? 0 : items.length,
//                  'pageSize': 5,
//                },
//              );
//              print(data.msg);
//              print(new DateTime.now());
//
//              //把请求到的新数据添加到items中
//              items.addAll(data.list);
//              print(data.allSize.toString() + "    " + items.length.toString());
////              return data.allSize == items.length;
//                return true;
//            },
//            itemBuilder: (List list, int index, BuildContext ctx) {
//              print(new DateTime.now());
//              // 项目信息列表项
//              return RepoItem(list[index]);
//            },
//          ),
          ListView(
            shrinkWrap: true,
//            padding: const EdgeInsets.all(20.0),
            itemExtent: 100.0,
            children: <Widget>[
              const Text('I\'m dedicating every day to you'),
              const Text('Domestic life was never quite my style'),
//              const Text('When you smile, you knock me out, I fall apart'),
              const Text('And I thought I was so smart'),
              const Text('当后台时间戳返回给前端时，前端要把时间戳转化为具体的时间，\n这个很简单，'
                  '\n使用DateTime方法就行。\n但是由于dart的时间戳要求是13位的，\n而后台返回给我们的可能是10位的，'
                  '\n这样就会造成转化的日期不对。'),
            ],
          ),
        ],
      ), // 构建主页面
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


class _InfiniteListViewState extends State<InfiniteListView>{

  static const loadingTag = '##loading##';
  var _words = <String>[loadingTag];

  void initState(){
    super.initState();
    _retrieveData();
  }

  void _retrieveData(){
//    Future.delayed(Duration(seconds: 2)).then((e){
//      _words.insertAll(_words.length - 1,
//          prefix0.generateWordPairs().take(20).map((e) => e.asPascalCase).toList()
//      );
//      setState(() {
//
//      });
//    });
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      separatorBuilder: (context,index) => Divider(height: .0,),
      itemCount: _words.length,
      itemBuilder: (context,index){
        if(_words[index] == loadingTag){
          if(_words.length - 1 < 100){
            //获取数据
            _retrieveData();
            //加载时显示loading
            return Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2,),
              ),
            );
          }else{
            return Container(
              alignment: Alignment.center,
              padding: EdgeInsets.all(16),
              child: Text('没有更多了',style:TextStyle(color: Colors.pink)),
            );
          }
        }
        return ListTile(title: Text(_words[index]));
      },
    );
  }
}