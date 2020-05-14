import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:punchcardclient/common/funs.dart';
import 'package:punchcardclient/common/git_api.dart';
import 'package:punchcardclient/common/global.dart';
import 'package:punchcardclient/entity/login_entity.dart';

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _LoginState createState()  => _LoginState();
}

class _LoginState extends State<LoginPage> {
  TextEditingController _seversIPController =
      new TextEditingController.fromValue(TextEditingValue(
    text: '192.168.1.105',
  ));
  TextEditingController _seversPortController =
      new TextEditingController.fromValue(TextEditingValue(
    text: '8080',
  ));
  TextEditingController _unameController =
      new TextEditingController.fromValue(TextEditingValue(
    text: '15210537077',
  ));
  TextEditingController _pwdController =
      new TextEditingController.fromValue(TextEditingValue(
    text: '123',
  ));
  bool pwdShow = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('登录')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          child: Wrap(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Expanded(
                    // flex设置权重
                    flex: 2,
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      controller: _seversIPController,
                      decoration: InputDecoration(
                        hintText: '服务端IP地址',
                      ),
                      //校验密码（不能为空）
                      validator: (v) {
                        return v.trim().isNotEmpty ? null : '服务端IP地址不能为空';
                      },
                    ),
                  ),
                  Expanded(
                    // flex设置权重
                    flex: 1,
                    child: Padding(
                      //左边添加16像素补白
                      padding: const EdgeInsets.only(left: 16.0),
                      child: TextFormField(
                        keyboardType: TextInputType.number,
                        controller: _seversPortController,
                        decoration: InputDecoration(
                          hintText: '8080',
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              TextFormField(
                  controller: _unameController,
                  maxLength: 11,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    labelText: '手机号',
                    hintText: '手机号',
                    prefixIcon: Icon(Icons.phone),
                  ),
                  // 校验用户名（不能为空）
                  validator: (v) {
                    return v.trim().isNotEmpty ? null : '用户名不能为空';
                  }),
              TextFormField(
                controller: _pwdController,
                decoration: InputDecoration(
                    labelText: '密码',
                    hintText: '密码',
                    prefixIcon: Icon(Icons.lock),
                    suffixIcon: IconButton(
                      icon: Icon(
                          pwdShow ? Icons.visibility_off : Icons.visibility),
                      onPressed: () {
                        setState(() {
                          pwdShow = !pwdShow;
                        });
                      },
                    )),
                obscureText: !pwdShow,
                //校验密码（不能为空）
                validator: (v) {
                  return v.trim().isNotEmpty ? null : '密码不能为空';
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 25),
                child: ConstrainedBox(
                  constraints: BoxConstraints.expand(height: 55.0),
                  child: RaisedButton(
                    color: Theme.of(context).primaryColor,
                    onPressed: _onLogin,
                    textColor: Colors.white,
                    child: Text('登录'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _onLogin() async {
    showLoading(context, "正在登录中……");
    var params = {
      'username': _unameController.text,
      'password': _pwdController.text
    };

    await Global.saveSP(
        "url",
        "http://" +
            _seversIPController.text +
            ":" +
            _seversPortController.text +
            "/");

    LoginEntity loginEntity = await Git(context).login(params);

    Global.saveSPInt("userId", loginEntity.memberId);
    Global.saveSPInt("type", loginEntity.type);

    showToast("登录成功");
    Navigator.of(context).pop();
    FocusScope.of(context).requestFocus(FocusNode());
    Navigator.of(context).pop();
    Navigator.pushNamed(context, "home");
  }
}
