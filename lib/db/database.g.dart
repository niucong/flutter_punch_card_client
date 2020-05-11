// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'database.dart';

// **************************************************************************
// FloorGenerator
// **************************************************************************

class $FloorFlutterDatabase {
  /// Creates a database builder for a persistent database.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder databaseBuilder(String name) =>
      _$FlutterDatabaseBuilder(name);

  /// Creates a database builder for an in memory database.
  /// Information stored in an in memory database disappears when the process is killed.
  /// Once a database is built, you should keep a reference to it and re-use it.
  static _$FlutterDatabaseBuilder inMemoryDatabaseBuilder() =>
      _$FlutterDatabaseBuilder(null);
}

class _$FlutterDatabaseBuilder {
  _$FlutterDatabaseBuilder(this.name);

  final String name;

  final List<Migration> _migrations = [];

  Callback _callback;

  /// Adds migrations to the builder.
  _$FlutterDatabaseBuilder addMigrations(List<Migration> migrations) {
    _migrations.addAll(migrations);
    return this;
  }

  /// Adds a database [Callback] to the builder.
  _$FlutterDatabaseBuilder addCallback(Callback callback) {
    _callback = callback;
    return this;
  }

  /// Creates the database and initializes it.
  Future<FlutterDatabase> build() async {
    final path = name != null
        ? join(await sqflite.getDatabasesPath(), name)
        : ':memory:';
    final database = _$FlutterDatabase();
    database.database = await database.open(
      path,
      _migrations,
      _callback,
    );
    return database;
  }
}

class _$FlutterDatabase extends FlutterDatabase {
  _$FlutterDatabase([StreamController<String> listener]) {
    changeListener = listener ?? StreamController<String>.broadcast();
  }

  CalendarDao _calendarDaoInstance;

  ScheduleDao _scheduleDaoInstance;

  Future<sqflite.Database> open(String path, List<Migration> migrations,
      [Callback callback]) async {
    return sqflite.openDatabase(
      path,
      version: 2,
      onConfigure: (database) async {
        await database.execute('PRAGMA foreign_keys = ON');
      },
      onOpen: (database) async {
        await callback?.onOpen?.call(database);
      },
      onUpgrade: (database, startVersion, endVersion) async {
        await MigrationAdapter.runMigrations(
            database, startVersion, endVersion, migrations);

        await callback?.onUpgrade?.call(database, startVersion, endVersion);
      },
      onCreate: (database, version) async {
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Calendar` (`sunday` TEXT, `saturday` TEXT, `tuesday` TEXT, `month` TEXT, `session` TEXT, `wednesday` TEXT, `thursday` TEXT, `friday` TEXT, `id` INTEGER, `weekly` TEXT, `monday` TEXT, PRIMARY KEY (`id`))');
        await database.execute(
            'CREATE TABLE IF NOT EXISTS `Schedule` (`sectionName` TEXT, `timeRank` TEXT, `id` INTEGER, `time` TEXT, PRIMARY KEY (`id`))');

        await callback?.onCreate?.call(database, version);
      },
    );
  }

  @override
  CalendarDao get calendarDao {
    return _calendarDaoInstance ??= _$CalendarDao(database, changeListener);
  }

  @override
  ScheduleDao get scheduleDao {
    return _scheduleDaoInstance ??= _$ScheduleDao(database, changeListener);
  }
}

class _$CalendarDao extends CalendarDao {
  _$CalendarDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _calendarInsertionAdapter = InsertionAdapter(
            database,
            'Calendar',
            (Calendar item) => <String, dynamic>{
                  'sunday': item.sunday,
                  'saturday': item.saturday,
                  'tuesday': item.tuesday,
                  'month': item.month,
                  'session': item.session,
                  'wednesday': item.wednesday,
                  'thursday': item.thursday,
                  'friday': item.friday,
                  'id': item.id,
                  'weekly': item.weekly,
                  'monday': item.monday
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _calendarMapper = (Map<String, dynamic> row) => Calendar(
      sunday: row['sunday'] as String,
      saturday: row['saturday'] as String,
      tuesday: row['tuesday'] as String,
      month: row['month'] as String,
      session: row['session'] as String,
      wednesday: row['wednesday'] as String,
      thursday: row['thursday'] as String,
      friday: row['friday'] as String,
      id: row['id'] as int,
      weekly: row['weekly'] as String,
      monday: row['monday'] as String);

  final InsertionAdapter<Calendar> _calendarInsertionAdapter;

  @override
  Future<List<Calendar>> findCalendar() async {
    return _queryAdapter.queryList('SELECT * FROM Calendar',
        mapper: _calendarMapper);
  }

  @override
  Future<void> insertCalendar(Calendar db) async {
    await _calendarInsertionAdapter.insert(db, sqflite.ConflictAlgorithm.abort);
  }
}

class _$ScheduleDao extends ScheduleDao {
  _$ScheduleDao(this.database, this.changeListener)
      : _queryAdapter = QueryAdapter(database),
        _scheduleInsertionAdapter = InsertionAdapter(
            database,
            'Schedule',
            (Schedule item) => <String, dynamic>{
                  'sectionName': item.sectionName,
                  'timeRank': item.timeRank,
                  'id': item.id,
                  'time': item.time
                });

  final sqflite.DatabaseExecutor database;

  final StreamController<String> changeListener;

  final QueryAdapter _queryAdapter;

  static final _scheduleMapper = (Map<String, dynamic> row) => Schedule(
      sectionName: row['sectionName'] as String,
      timeRank: row['timeRank'] as String,
      id: row['id'] as int,
      time: row['time'] as String);

  final InsertionAdapter<Schedule> _scheduleInsertionAdapter;

  @override
  Future<List<Schedule>> findSchedule() async {
    return _queryAdapter.queryList('SELECT * FROM Schedule',
        mapper: _scheduleMapper);
  }

  @override
  Future<void> insertSchedule(Schedule db) async {
    await _scheduleInsertionAdapter.insert(db, sqflite.ConflictAlgorithm.abort);
  }
}
