import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/funs.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/entity/basic_entity.dart';
import 'package:punchcardclient/entity/member_list_enity.dart';

class PlanRoute extends StatefulWidget {
  @override
  _PlanRouteState createState() => _PlanRouteState();
}

class _PlanRouteState extends State<PlanRoute> {
  var _members = "请点击选择";
  var _timeStart = "请选择开始时间";
  var _timeEnd = "请选择结束时间";
  TextEditingController _controller = new TextEditingController();

  bool isDetail = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('计划'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Wrap(
          children: <Widget>[
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Text(
                    "计划名称：",
                    textScaleFactor: 1.3,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: TextFormField(
//              readOnly: isDetail,
                    decoration: InputDecoration(
                      hintText: '请输入名称',
//                border: isDetail ? InputBorder.none : null,
                    ),
                    controller: _controller,
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Text(
                    "关联人员：",
                    textScaleFactor: 1.3,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$_members',
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ),
                    onPressed: isDetail
                        ? null
                        : () {
                            if (listData.isEmpty) {
                              Git(context).getMemberList(
                                {},
                              ).then((MemberListEntity e) {
                                listData.addAll(e.list);
                                _showDialog();
                              });
                            } else {
                              _showDialog();
                            }
                          },
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Text(
                    "开始时间：",
                    textScaleFactor: 1.3,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          '$_timeStart',
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ),
                    onPressed: isDetail
                        ? null
                        : () {
                            _showDataTimePicker(0);
                          },
                  ),
                ),
              ],
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Text(
                    "结束时间：",
                    textScaleFactor: 1.3,
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: MaterialButton(
                    child: Container(
                      child: Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          "$_timeEnd",
                          textScaleFactor: 1.3,
                        ),
                      ),
                    ),
                    onPressed: isDetail
                        ? null
                        : () {
                            _showDataTimePicker(1);
                          },
                  ),
                ),
              ],
            ),
            Visibility(
              visible: !isDetail,
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  await Git(context).vacate(
                    {
                      'cause': _controller.text,
                      'start':
                          DateTime.parse(_timeStart).millisecondsSinceEpoch,
                      'end': DateTime.parse(_timeEnd).millisecondsSinceEpoch,
                    },
                  ).then((BasicEntity e) {
                    showToast(e.msg);
                    Navigator.of(context).pop(true);
                  });
                },
                textColor: Colors.white,
                child: Text('提交'),
              ),
            ),
          ],
        ),
      ),
      // 构建主页面
    );
  }

  final List<MemberEntity> listData = [];
  final boolList = List<bool>();

  //显示多选框
  _showDialog() async {
    await showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(builder: (context, state) {
            return CupertinoAlertDialog(
              title: Text('请选择'),
              actions: <Widget>[
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      Navigator.of(context).pop('取消');
                    },
                    child: new Text('取消')),
                CupertinoDialogAction(
                    isDestructiveAction: true,
                    onPressed: () {
                      _members = "";
                      for (int i = 0; i < boolList.length; i++) {
                        if (boolList[i]) {
                          _members += ";" + listData[i].name;
                        }
                      }
                      if (_members.length > 0) {
                        _members = _members.substring(1);
                      }
                      setState(() {});
                      Navigator.of(context).pop('确定');
                    },
                    child: new Text('确定')),
              ],
              content: SingleChildScrollView(
                child: Material(
                  child: Column(children: _getMulitiWidget(listData, state)),
                  color: Color(0x00000000),
                ),
              ),
            );
          });
        });
  }

  List<Widget> _getMulitiWidget(List<MemberEntity> list, state) {
    List<Widget> widgetList = List<Widget>();
    for (int i = 0; i < list.length; i++) {
      boolList.add(false);
      widgetList.add(Container(
        child: CheckboxListTile(
            title: Text(list[i].name),
            value: boolList[i],
            onChanged: (value) {
              boolList[i] = value;
              state(() {});
            }),
      ));
    }
    ;
    return widgetList;
  }

  _showDataTimePicker(int type) async {
    if (!isDetail) {
      Locale myLocale = Localizations.localeOf(context);
      var pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2022),
        locale: myLocale,
      );
      var pickerTime =
          await showTimePicker(context: context, initialTime: TimeOfDay.now());
      setState(() {
        if (type == 0) {
          _timeStart = pickerDate.toString().substring(0, 10) +
              " " +
              pickerTime.toString().substring(10, 15);
        } else {
          _timeEnd = pickerDate.toString().substring(0, 10) +
              " " +
              pickerTime.toString().substring(10, 15);
        }
      });
    }
  }
}
