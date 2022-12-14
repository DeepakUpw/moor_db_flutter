
import 'package:moor_flutter/moor_flutter.dart';
part 'app_database.g.dart';

class Tasks extends Table{
  // autoIncrement automatically sets this to be the primary key

  IntColumn get id => integer().autoIncrement().nullable()();
  // If the length constraint is not fulfilled, the Task will not
  // be inserted into the database and an exception will be thrown.
  TextColumn get name => text().withLength(min: 1, max: 50)();
  // DateTime is not natively supported by SQLite
  // Moor converts it to & from UNIX seconds
  DateTimeColumn get dueDate => dateTime().nullable()();
  // Booleans are not supported as well, Moor converts them to integers
  // Simple default values are specified as Constants
  BoolColumn get completed => boolean().withDefault(const Constant(false)).nullable()();

}

@UseMoor(tables : [Tasks])
class AppDatabase extends _$AppDatabase{
  AppDatabase() : super(FlutterQueryExecutor.inDatabaseFolder(
      path: 'db.sqLite',
      // good for debugging - prints SQL in the console
      logStatements: true
  ));

  @override
  int get schemaVersion => 1;

  // All tables have getters in the generated class - we can select the tasks table
  Future<List<Task>> getAllTasks() => select(tasks).get();
  // Moor supports Streams which emit elements when the watched data changes
  Stream<List<Task>> watchAllTasks() => select(tasks).watch();

  Future insertTask(Task task) => into(tasks).insert(task);

  // Updates a Task with a matching primary key
  Future updateTask(Task task) => update(tasks).replace(task);


  Future deleteTask(Task task) => delete(tasks).delete(task);

}
