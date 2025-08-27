import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import '../tables/habits_table.dart';
import '../tables/users_table.dart';


part 'app_database.g.dart';

@DriftDatabase(tables: [UsersTable, HabitsTable])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'habit_tracker.sqlite'));

  @override
  int get schemaVersion => 1;

  Future<int> insertUser(UsersTableCompanion user) =>
      into(usersTable).insertOnConflictUpdate(user);

  Future<User?> getUserByUsername(String username) =>
      (select(usersTable)..where((t) => t.username.trim().equals(username)))
          .getSingleOrNull();
  Future<User?> getUserById(int userID) =>
      (select(usersTable)..where((t) => t.id.equals(userID)))
          .getSingleOrNull();

  Future<List<User>> getAllUsers() => select(usersTable).get();

  Future<bool> updateUser(User user) => update(usersTable).replace(user);

  Future<int> deleteUserByUsername(String username) =>
      (delete(usersTable)..where((t) => t.username.equals(username))).go();

  // ---------------- HABITS ----------------
  Future<int> insertHabit(HabitsTableCompanion habit) =>
      into(habitsTable).insert(habit);

  Future<List<Habit>> getHabitsByID(int id) async {

    return (select(habitsTable)..where((h) => h.userId.equals(id))).get();
  }

  Future<int> deleteHabit(int id) =>
      (delete(habitsTable)..where((tbl) => tbl.id.equals(id))).go();

  Future<int> updateHabit(Habit updatedHabit) {
    return (update(habitsTable)..where((tbl) => tbl.id.equals(updatedHabit.id))).write(updatedHabit);
  }
}