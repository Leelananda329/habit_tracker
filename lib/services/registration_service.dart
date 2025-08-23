import 'package:drift/drift.dart';
import '../app_database/app_database.dart';


class RegistrationService {
  final AppDatabase db = AppDatabase();

  /// Register or update user (username is unique key)
  Future<void> registerUser({
    required String name,
    required String username,
    required String password,
    double? age,
    String? country,
    List<String>? habits,
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
      for (final h in habits) {
        await db.insertHabit(
          HabitsTableCompanion.insert(
            userId: userId,
            title: h,
          ),
        );
      }
    }
  }

  /// Fetch user and habits by username
  Future<Map<String, dynamic>?> getUserWithHabits(String username) async {
    final user = await db.getUserByUsername(username);
    if (user == null) return null;

    final habits = await db.getHabitsForUsername(username);
    return {
      "user": user,
      "habits": habits,
    };
  }



  /// Delete user by username
  Future<void> deleteUser(String username) async {
    await db.deleteUserByUsername(username);
  }
}