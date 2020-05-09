class SignListEntity {
  String msg;
  int allSize;
  int code;
  List<SignList> list;

  SignListEntity({this.msg, this.allSize, this.code, this.list});

  SignListEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    allSize = json['allSize'];
    code = json['code'];
    if (json['list'] != null) {
      list = new List<SignList>();
      json['list'].forEach((v) {
        list.add(new SignList.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['msg'] = this.msg;
    data['allSize'] = this.allSize;
    data['code'] = this.code;
    if (this.list != null) {
      data['list'] = this.list.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class SignList {
  String name;
  int startTime;
  int id;
  int superId;
  int endTime;
  int memberId;

  SignList(
      {this.name,
        this.startTime,
        this.id,
        this.superId,
        this.endTime,
        this.memberId});

  SignList.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    startTime = json['startTime'];
    id = json['id'];
    superId = json['superId'];
    endTime = json['endTime'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['startTime'] = this.startTime;
    data['id'] = this.id;
    data['superId'] = this.superId;
    data['endTime'] = this.endTime;
    data['memberId'] = this.memberId;
    return data;
  }
}