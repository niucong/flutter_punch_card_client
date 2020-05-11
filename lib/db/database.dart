import 'dart:async';

import 'package:floor/floor.dart';
import 'package:path/path.dart';
import 'package:punchcardclient/db/schedule_dao.dart';
import 'package:punchcardclient/entity/calendar_list_entity.dart';
import 'package:punchcardclient/entity/schedule_list_entity.dart';
import 'package:sqflite/sqflite.dart' as sqflite;

import 'calendar_dao.dart';

part 'database.g.dart';

@Database(version: 2, entities: [Calendar, Schedule])
abstract class FlutterDatabase extends FloorDatabase {
  CalendarDao get calendarDao;

  ScheduleDao get scheduleDao;
}
