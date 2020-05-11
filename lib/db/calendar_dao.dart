import 'package:floor/floor.dart';
import 'package:punchcardclient/entity/calendar_list_entity.dart';

@dao
abstract class CalendarDao {
  @Query('SELECT * FROM Calendar')
  Future<List<Calendar>> findCalendar();

//  @Query('SELECT * FROM Calendar WHERE id = :id')
//  Stream<CalendarDB> findPersonById(int id);

  @insert
  Future<void> insertCalendar(Calendar db);
}
