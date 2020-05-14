import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/funs.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/common/global.dart';
import 'package:punchcardclient/entity/basic_entity.dart';
import 'package:punchcardclient/entity/member_list_enity.dart';
import 'package:punchcardclient/entity/plan_list_entity.dart';

class PlanRoute extends StatefulWidget {
  PlanList listItem;

  PlanRoute({this.listItem});

  @override
  _PlanRouteState createState() => _PlanRouteState(this.listItem);
}

class _PlanRouteState extends State<PlanRoute> {
  var members;
  var _members = "请点击选择";
  var _timeStart = "请选择开始时间";
  var _timeEnd = "请选择结束时间";
  TextEditingController _controller = new TextEditingController();
  TextEditingController _controllerCause = new TextEditingController();

  bool isOwner = false;
  bool isDetail = false;
  PlanList planEntity;
  var editTime = 0;

  bool _checkboxSelected = false;

  _PlanRouteState(PlanList listItem) {
    this.planEntity = listItem;
    if (listItem != null) {
      _timeStart = DateTime.fromMillisecondsSinceEpoch(listItem.startTime)
          .toString()
          .substring(0, 16);
      _timeEnd = DateTime.fromMillisecondsSinceEpoch(listItem.endTime)
          .toString()
          .substring(0, 16);
      _controller.text = listItem.name;

      List list = json.decode(listItem.members);
      _members = "";
      for (int i = 0; i < list.length; i++) {
        _members += ";" + list[i]["name"];
      }
      if (_members.length > 0) {
        _members = _members.substring(1);
      }
      Global.getSPInt("key")
          .then((value) => isOwner = value == listItem.creatorId);

      editTime = planEntity.editTime;
      isDetail = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    var creatorName = "";
    var status = "";
    var operate = "";
    var color;
    if (isDetail) {
      creatorName = "创建者：" + planEntity.creatorName;
      status = "计划状态：";
      if (planEntity.forceFinish == 0) {
        if (planEntity.startTime > new DateTime.now().millisecondsSinceEpoch) {
          status = "未开始";
          operate = "取消计划";
          color = Colors.blue;
        } else if (planEntity.endTime >
            new DateTime.now().millisecondsSinceEpoch) {
          status = "进行中";
          operate = "终止计划";
          color = Colors.green;
        } else {
          status = "已结束";
          color = Colors.black26;
        }
      } else if (planEntity.forceFinish == 1) {
        status = "已取消";
        color = Colors.orange;
      } else {
        status = "已终止";
        color = Colors.red;
      }
    }
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
                    readOnly: isDetail,
                    decoration: InputDecoration(
                      hintText: '请输入名称',
                      border: isDetail ? InputBorder.none : null,
                    ),
                    controller: _controller,
                  ),
                ),
              ],
            ),
            Visibility(
              visible: isDetail,
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Text(
                  creatorName,
                  textScaleFactor: 1.3,
                ),
              ),
            ),
            Flex(
              direction: Axis.horizontal,
              children: <Widget>[
                Expanded(
                  flex: 0,
                  child: Container(
                    margin: EdgeInsets.only(top: 5),
                    child: Text(
                      "关联人员：",
                      textScaleFactor: 1.3,
                    ),
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
              visible: editTime > 0,
              child: Flex(
                direction: Axis.horizontal,
                children: <Widget>[
                  Expanded(
                    flex: 0,
                    child: Text(
                      "修改时间：",
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
                            DateTime.fromMillisecondsSinceEpoch(editTime)
                                .toLocal()
                                .toString()
                                .substring(0, 16),
                            textScaleFactor: 1.3,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isDetail,
              child: Container(
                margin: EdgeInsets.only(top: 10, bottom: 10),
                child: Flex(
                  direction: Axis.horizontal,
                  children: <Widget>[
                    Expanded(
                      flex: 0,
                      child: Text(
                        "计划状态：",
                        textScaleFactor: 1.3,
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Text(
                        status,
                        textScaleFactor: 1.3,
                        style: TextStyle(
                          color: color,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: isDetail && isOwner && planEntity.editTime == 0,
              child: Row(
                children: <Widget>[
                  Checkbox(
                    value: _checkboxSelected,
                    activeColor: Colors.red, //选中时的颜色
                    onChanged: (value) {
                      setState(() {
                        _checkboxSelected = value;
                      });
                    },
                  ),
                  Text(
                    operate,
                    textScaleFactor: 1.3,
                  ),
                ],
              ),
            ),
            Visibility(
              visible: isDetail && _checkboxSelected,
              child: TextFormField(
                decoration: InputDecoration(
                  hintText: '取消/终止原因',
                ),
                controller: _controllerCause,
              ),
            ),
            Visibility(
              visible: !isDetail || _checkboxSelected,
              child: RaisedButton(
                padding: EdgeInsets.all(10.0),
                color: Theme.of(context).primaryColor,
                onPressed: () async {
                  if (!isDetail && selectData.length == 0) {
                    showToast("请先选择关联人员");
                  } else {
                    Map params;
                    if (isDetail) {
                      params = {
                        'serverId': planEntity.id,
                        'forceFinish': planEntity.startTime >
                                new DateTime.now().millisecondsSinceEpoch
                            ? 1
                            : 2,
                        'cause': _controllerCause.text,
                      };
                    } else {
                      params = {
                        'name': _controller.text,
                        'start':
                            DateTime.parse(_timeStart).millisecondsSinceEpoch,
                        'end': DateTime.parse(_timeEnd).millisecondsSinceEpoch,
                        'members': json.encode(selectData),
                      };
                    }
                    await Git(context)
                        .plan(
                      params,
                    )
                        .then((BasicEntity e) {
                      showToast(e.msg);
                      Navigator.of(context).pop(true);
                    });
                  }
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
  final List<MemberEntity> selectData = [];
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
                      selectData.clear();
                      for (int i = 0; i < boolList.length; i++) {
                        if (boolList[i]) {
                          _members += ";" + listData[i].name;
                          selectData.add(listData[i]);
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
      var pickerDate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2020),
        lastDate: DateTime(2022),
        locale: Locale('zh'),
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
