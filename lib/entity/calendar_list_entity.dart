class CalendarListEntity {
  String msg;
  int code;
  List<CalendarList> list;

  CalendarListEntity({this.msg, this.code, this.list});

  CalendarListEntity.fromJson(Map<String, dynamic> json) {
    msg = json['msg'];
    code = json['code'];
    if (json['list'] != null) {
      list = new List<CalendarList>();
      json['list'].forEach((v) {
        list.add(new CalendarList.fromJson(v));
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

class CalendarList {
  String sunday;
  String saturday;
  String tuesday;
  String month;
  String session;
  String wednesday;
  String thursday;
  String friday;
  int id;
  String weekly;
  String monday;

  CalendarList(
      {this.sunday,
      this.saturday,
      this.tuesday,
      this.month,
      this.session,
      this.wednesday,
      this.thursday,
      this.friday,
      this.id,
      this.weekly,
      this.monday});

  CalendarList.fromJson(Map<String, dynamic> json) {
    sunday = json['sunday'];
    saturday = json['saturday'];
    tuesday = json['tuesday'];
    month = json['month'];
    session = json['session'];
    wednesday = json['wednesday'];
    thursday = json['thursday'];
    friday = json['friday'];
    id = json['id'];
    weekly = json['weekly'];
    monday = json['monday'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sunday'] = this.sunday;
    data['saturday'] = this.saturday;
    data['tuesday'] = this.tuesday;
    data['month'] = this.month;
    data['session'] = this.session;
    data['wednesday'] = this.wednesday;
    data['thursday'] = this.thursday;
    data['friday'] = this.friday;
    data['id'] = this.id;
    data['weekly'] = this.weekly;
    data['monday'] = this.monday;
    return data;
  }
}
