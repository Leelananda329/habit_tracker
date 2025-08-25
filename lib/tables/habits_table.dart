import 'package:drift/drift.dart';
import 'package:habit_tracker/tables/users_table.dart';

@DataClassName('Habit')
class HabitsTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get userId =>
      integer().references(UsersTable, #id, onDelete: KeyAction.cascade)();
  TextColumn get title => text()();
  BoolColumn get isCompleted => boolean().withDefault(const Constant(false))();
  DateTimeColumn get createdAt => dateTime().withDefault(currentDateAndTime)();
  TextColumn get color => text()();
}