import 'package:floor/floor.dart';

class ScheduleListEntity {
  String msg;
  int code;
  List<Schedule> list;

  ScheduleListEntity({this.msg, this.code, this.list});

  ScheduleListEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['list'] != null) {
      list = new List<Schedule>();
      json['list'].forEach((v) {
        list.add(new Schedule.fromJson(v));
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

@entity
class Schedule {
  String sectionName; // 节次
  String timeRank; // 时段：上午、下午、晚上
  @primaryKey
  int id;
  String time; // 上课时间

  Schedule({this.sectionName, this.timeRank, this.id, this.time});

  Schedule.fromJson(Map<String, dynamic> json) {
    sectionName = json['sectionName'];
    timeRank = json['timeRank'];
    id = json['id'];
    time = json['time'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sectionName'] = this.sectionName;
    data['timeRank'] = this.timeRank;
    data['id'] = this.id;
    data['time'] = this.time;
    return data;
  }
}
