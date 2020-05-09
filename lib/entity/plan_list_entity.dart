class PlanListEntity {
  String msg;
  int allSize;
  int code;
  List<PlanList> list;

  PlanListEntity({this.msg, this.allSize, this.code, this.list});

  PlanListEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    allSize = json['allSize'];
    code = json['code'];
    if (json['list'] != null) {
      list = new List<PlanList>();
      json['list'].forEach((v) {
        list.add(new PlanList.fromJson(v));
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

class PlanList {
  int createTime;
  int forceFinish;
  String members;
  String name;
  int creatorId;
  String creatorName;
  int startTime;
  int editTime;
  int id;
  int endTime;

  PlanList(
      {this.createTime,
      this.forceFinish,
      this.members,
      this.name,
      this.creatorId,
      this.creatorName,
      this.startTime,
      this.editTime,
      this.id,
      this.endTime});

  PlanList.fromJson(Map<String, dynamic> json) {
    createTime = json['createTime'];
    forceFinish = json['forceFinish'];
    members = json['members'];
    name = json['name'];
    creatorId = json['creatorId'];
    creatorName = json['creatorName'];
    startTime = json['startTime'];
    editTime = json['editTime'];
    id = json['id'];
    endTime = json['endTime'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['createTime'] = this.createTime;
    data['forceFinish'] = this.forceFinish;
    data['members'] = this.members;
    data['name'] = this.name;
    data['creatorId'] = this.creatorId;
    data['creatorName'] = this.creatorName;
    data['startTime'] = this.startTime;
    data['editTime'] = this.editTime;
    data['id'] = this.id;
    data['endTime'] = this.endTime;
    return data;
  }
}
