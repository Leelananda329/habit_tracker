import 'package:shared_preferences/shared_preferences.dart';

import 'app_database/app_database.dart';

class LocalStorage {
  SharedPreferences? _prefs;
  final db = AppDatabase();
  // Private constructor
  LocalStorage._privateConstructor();

  // Static instance
  static final LocalStorage _instance = LocalStorage._privateConstructor();

  // Factory constructor
  factory LocalStorage() {
    return _instance;
  }

  // Getter for prefs (throws if not initialized)
  SharedPreferences get prefs {
    if (_prefs == null) {
      throw Exception("SharedPreferences not initialized. Call init() first.");
    }
    return _prefs!;
  }

  // Initialize SharedPreferences (call once at app start)
  Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  // ------------------ SETTERS ------------------
  Future<void> setName(String name) async => await prefs.setString('name', name);

  Future<void> setUsername(String username) async => await prefs.setString('username', username);

  Future<void> setPassword(String password) async => await prefs.setString('password', password);

  Future<void> setAge(double age) async => await prefs.setDouble('age', age);

  Future<void> setCountry(String country) async => await prefs.setString('country', country);

  Future<void> setHabits(List<String> habits) async => await prefs.setStringList('habits', habits);

  // ------------------ GETTERS ------------------
  String? getName() => prefs.getString('name');

  String? getUsername() => prefs.getString('username');

  String? getPassword() => prefs.getString('password');

  double? getAge() => prefs.getDouble('age');

  String? getCountry() => prefs.getString('country');

  int? getUserID() => prefs.getInt('userID');

  List<String>? getHabits() => prefs.getStringList('habits');

  Future<void> setUserID(int id) async => await prefs.setInt('userID', id);

  Future<void> setWeeklyData(String jsonEncode) async {

    prefs.setString('weeklyData', jsonEncode);
  }

  String? getWeeklyData() => prefs.getString('weeklyData');

  Future<void> clear() async {
    prefs.clear();

  }

  void setIsSignIn(bool rememberMe) {

    prefs.setBool('isSignIn', rememberMe);
  }

  bool? getIsSignIn() {
    return prefs.getBool('isSignIn');
  }



}