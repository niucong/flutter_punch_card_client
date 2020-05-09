class VacateListEntity {
  String msg;
  int allSize;
  int code;
  List<VacateList> list;

  VacateListEntity({this.msg, this.allSize, this.code, this.list});

  VacateListEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    allSize = json['allSize'];
    code = json['code'];
    if (json['list'] != null) {
      list = new List<VacateList>();
      json['list'].forEach((v) {
        list.add(new VacateList.fromJson(v));
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

class VacateList {
  int createTime;
  int approveResult;
  String name;
  String cause;
  int startTime;
  int editTime;
  int id;
  int superId;
  int endTime;
  int type;
  int memberId;

  VacateList(
      {this.createTime,
      this.approveResult,
      this.name,
      this.cause,
      this.startTime,
      this.editTime,
      this.id,
      this.superId,
      this.endTime,
      this.type,
      this.memberId});

  VacateList.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    approveResult = json['approveResult'];
    name = json['name'];
    cause = json['cause'];
    startTime = json['startTime'];
    editTime = json['editTime'];
    id = json['id'];
    superId = json['superId'];
    endTime = json['endTime'];
    type = json['type'];
    memberId = json['memberId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['approveResult'] = this.approveResult;
    data['name'] = this.name;
    data['cause'] = this.cause;
    data['startTime'] = this.startTime;
    data['editTime'] = this.editTime;
    data['id'] = this.id;
    data['superId'] = this.superId;
    data['endTime'] = this.endTime;
    data['type'] = this.type;
    data['memberId'] = this.memberId;
    return data;
  }
}
