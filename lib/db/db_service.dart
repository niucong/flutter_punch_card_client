import 'package:floor/floor.dart';
import 'package:punchcardclient/db/calendar_dao.dart';

import 'database.dart';

final dbService = DBService();

class DBService {
  Future<CalendarDao> getCalendarDao() async {
    final dataBase = await $FloorFlutterDatabase
        .databaseBuilder('database.db')
        .addMigrations(<Migration>[
      Migration(1, 2, (db) {
        // db.execute('ALTER TABLE Work ADD COLUMN create_time TEXT');
      }),
    ]).build();
    return dataBase.calendarDao;
  }
}
