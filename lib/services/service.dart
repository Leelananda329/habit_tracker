import 'dart:ui';

import 'package:drift/drift.dart';
import '../app_database/app_database.dart';


class DatabaseServices {
  final AppDatabase db = AppDatabase();

  /// Register or update user (username is unique key)
  Future<void> registerUser({
    required String name,
    required String username,
    required String password,
    double? age,
    String? country,
    Map<String, String>? habits,
  }) async {
    // Insert/update user
    final userCompanion = UsersTableCompanion.insert(
      name: name,
      username: username,
      password: password,
      age: age != null ? Value(age) : const Value.absent(),
      country: country != null ? Value(country) : const Value.absent(),
    );

    final userId = await db.insertUser(userCompanion);

    // Insert habits if provided
    if (habits != null) {
      for (final entry in habits.entries) {
        await db.insertHabit(
          HabitsTableCompanion.insert(
            userId: userId,
            title: entry.key,
            color: entry.value,
          ),
        );
      }
    }
  }

  /// Fetch user and habits by username
  Future<User?> getUserByName(String username) async {
    final user = await db.getUserByUsername(username);
    if (user == null) return null;


    return user;
  }

  /// Get all users
  Future<List<User>> getAllUsers() async {
    return await db.getAllUsers();
  }

  /// Get user by ID
  Future<User?> getUserById(int id) async {
    return await db.getUserById(id);
  }

  /// Update user
  Future<void> updateUser(User user) async {
    await db.updateUser(user);
  }

  /// Delete user by ID
  /*Future<void> deleteUserById(int id) async {
    await db.deleteUserById(id);
  }*/

  /// Get all habits for a user
  Future<List<Habit>> getHabitsByUserId(int userId) async {
    return await db.getHabitsByID(userId);
  }

  /// Get habit by ID
  Future<List<Habit>> getHabitById(int id) async {
    return await db.getHabitsByID(id);
  }

  /// Update habit
  Future<void> updateHabit(Habit habit) async {
    await db.updateHabit(habit);
  }

  /// Delete habit by ID
  Future<void> deleteHabitById(int id) async {
    await db.deleteHabit(id);
  }



  /// Delete user by username
  Future<void> deleteUser(String username) async {
    await db.deleteUserByUsername(username);
  }


  Future<List<Habit>?> getUserWithHabits(String username) async {
    final user = await db.getUserByUsername(username);
    if (user == null) return null;

    final habit= await db.getHabitsByID(user.id);

    return habit;
  }

  /// Insert a new hobby
  Future<void> insertHobby({required int userId, required String title, required String color}) async {
    await db.insertHabit(HabitsTableCompanion.insert(
      userId: userId,
      title: title,
      color: color,
    ));
  }

}