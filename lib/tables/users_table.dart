import 'package:drift/drift.dart';

@DataClassName('User')
class UsersTable extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  TextColumn get username => text().unique()();
  TextColumn get password => text()(); // hash in production
  RealColumn get age => real().nullable()();
  TextColumn get country => text().nullable()();
}