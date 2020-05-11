import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/funs.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/common/global.dart';
import 'package:punchcardclient/entity/basic_entity.dart';
import 'package:punchcardclient/entity/vacate_list_entity.dart';

class VacateRoute extends StatefulWidget {
  VacateList listItem;

  VacateRoute({this.listItem});

  @override
  _VacateRouteState createState() => _VacateRouteState(this.listItem);
}

class _VacateRouteState extends State<VacateRoute> {
  int type = 1;
  var _timeStart = "请选择开始时间";
  var _timeEnd = "请选择结束时间";
  TextEditingController _controller = new TextEditingController();

  VacateList listItem;

  bool isStudent = false;
  bool isDetail = false;

  _VacateRouteState(VacateList listItem) {
    Global.getSPInt("type").then((int type) {
      isStudent = type == 3;
      setState(() {});
    });
    if (listItem != null) {
      _timeStart = DateTime.fromMillisecondsSinceEpoch(listItem.startTime)
          .toString()
          .substring(0, 16);
      _timeEnd = DateTime.fromMillisecondsSinceEpoch(listItem.endTime)
          .toString()
          .substring(0, 16);
      _controller.text = listItem.cause;
      type = listItem.type;
      isDetail = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('假条'),
      ),
      body: Container(
        margin: const EdgeInsets.all(16.0),
        child: Wrap(
          children: <Widget>[
            Row(
              children: <Widget>[],
            ),
            Wrap(
              crossAxisAlignment: WrapCrossAlignment.center,
              children: <Widget>[
                Text(
                  "请假类型：",
                  textScaleFactor: 1.3,
                ),
                Radio(
                  value: 1,
                  groupValue: type,
                  onChanged: isDetail
                      ? null
                      : (value) {
                          setState(() {
                            type = value;
                          });
                        },
                ),
                Text("事假"),
                Radio(
                  value: 2,
                  groupValue: type,
                  onChanged: isDetail
                      ? null
                      : (value) {
                          setState(() {
                            type = value;
                          });
                        },
                ),
                Text("病假"),
              ],
            ),
            Visibility(
              visible: !isStudent,
              child: Row(
                children: <Widget>[
                  Radio(
                    value: 3,
                    groupValue: type,
                    onChanged: isDetail
                        ? null
                        : (value) {
                            setState(() {
                              type = value;
                            });
                          },
                  ),
                  Text("年假"),
                  Radio(
                    value: 4,
                    groupValue: type,
                    onChanged: isDetail
                        ? null
                        : (value) {
                            setState(() {
                              type = value;
                            });
                          },
                  ),
                  Text("调休"),
                  Radio(
                    value: 5,
                    groupValue: type,
                    onChanged: isDetail
                        ? null
                        : (value) {
                            setState(() {
                              type = value;
                            });
                          },
                  ),
                  Text("其它"),
                ],
              ),
            ),
            Text(
              "请假原因：",
              textScaleFactor: 1.3,
            ),
            TextFormField(
              readOnly: isDetail,
              decoration: InputDecoration(
                hintText: '请输入原因',
                border: isDetail ? InputBorder.none : null,
              ),
              controller: _controller,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "开始时间：",
                  textScaleFactor: 1.3,
                ),
                MaterialButton(
                  child: Text('$_timeStart'),
                  onPressed: isDetail
                      ? null
                      : () {
                          _showDataTimePicker(0);
                        },
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Text(
                  "结束时间：",
                  textScaleFactor: 1.3,
                ),
                MaterialButton(
                  child: Text("$_timeEnd"),
                  onPressed: isDetail
                      ? null
                      : () {
                          _showDataTimePicker(1);
                        },
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
                      'type': type,
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
