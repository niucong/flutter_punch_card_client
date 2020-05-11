import 'package:floor/floor.dart';
import 'package:punchcardclient/entity/schedule_list_entity.dart';

@dao
abstract class ScheduleDao {
  @Query('SELECT * FROM Schedule')
  Future<List<Schedule>> findSchedule();

//  @Query('SELECT * FROM Schedule WHERE id = :id')
//  Stream<Schedule> findScheduleById(int id);

  @insert
  Future<void> insertSchedule(Schedule db);
}
