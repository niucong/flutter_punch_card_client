class LoginEntity {
  String msg;
  int code;
  int type;
  int memberId;

  LoginEntity({this.msg, this.code, this.type, this.memberId});

  LoginEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    type = json['type'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    data['type'] = this.type;
    data['memberId'] = this.memberId;
    return data;
  }
}
