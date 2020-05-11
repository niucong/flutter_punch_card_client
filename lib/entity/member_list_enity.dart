class MemberListEntity {
  String msg;
  int code;
  List<MemberEntity> list;

  MemberListEntity({this.msg, this.code, this.list});

  MemberListEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['list'] != null) {
      list = new List<MemberEntity>();
      json['list'].forEach((v) {
        list.add(new MemberEntity.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['code'] = this.code;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class MemberEntity {
  String number;
  String phone;
  String name;
  int id;
  int superId;
  int type;

  MemberEntity(
      {this.number, this.phone, this.name, this.id, this.superId, this.type});

  MemberEntity.fromJson(Map<String, dynamic> json) {
    number = json['number'];
    phone = json['phone'];
    name = json['name'];
    id = json['id'];
    superId = json['superId'];
    type = json['type'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['number'] = this.number;
    data['phone'] = this.phone;
    data['name'] = this.name;
    data['id'] = this.id;
    data['superId'] = this.superId;
    data['type'] = this.type;
    return data;
  }
}
