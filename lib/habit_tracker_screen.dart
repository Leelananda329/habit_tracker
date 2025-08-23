import 'package:flutter/material.dart';
import 'package:habit_tracker/app_database/app_database.dart';
import 'package:habit_tracker/constants/app_constants.dart';
import 'package:habit_tracker/local_storage.dart';
import 'package:habit_tracker/services/registration_service.dart';

import 'app_colors/app_color.dart';
import 'habit_details_screen.dart';

class HabitTrackerScreen extends StatefulWidget {


  const HabitTrackerScreen({super.key, });

  @override
  _HabitTrackerScreenState createState() => _HabitTrackerScreenState();
}

class _HabitTrackerScreenState extends State<HabitTrackerScreen> {
  
  
  String name = '';
  String userName = '';

  List<Habit>? todoHabitsData;
  List<Habit>? completedHobitData;
  final AppDatabase db = AppDatabase();

  @override
  void initState() {

    name=LocalStorage().getName()??'Habits';
    userName=LocalStorage().getUsername()??'';
     getSelectedHobits(userName);

    super.initState();
  }

  Future<void> _saveHabits(Habit habit, {required bool completed}) async {
    // Update the habit's completion status
    final updatedHabit = habit.copyWith(isCompleted: completed);
    await db.updateHabit(updatedHabit);
    // Refresh the lists after the database update
    await getSelectedHobits(userName); // This will call setState
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text(
          name.isNotEmpty ? name : 'Loading...',
          style: const TextStyle(
            fontSize: 24,
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.white), // Ensure drawer icon is white

          actions: [
            IconButton(
              icon: const Icon(Icons.person),
              onPressed: () {
                // Handle logout
                Navigator.pop(context);})
          ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue.shade700,
              ),
              child: const Text(
                AppConstants.menu,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.list),
              title: const Text(AppConstants.habits),
              onTap: () {
                // Navigate to home or close drawer
                Navigator.pop(context);
              },
            ),
            ListTile(
              leading: Icon(Icons.person),
              title: Text(AppConstants.personalInfo),
              onTap: () {
                // Navigate to settings page
                Navigator.pop(context);
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.book),
              title: Text(AppConstants.reports),
              onTap: () {
                // Navigate to settings page
                Navigator.pop(context);
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.notifications),
              title: Text(AppConstants.notification),
              onTap: () {
                // Navigate to settings page
                Navigator.pop(context);
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text(AppConstants.settings),
              onTap: () {
                // Navigate to settings page
                Navigator.pop(context);
                // Example: Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(AppConstants.Logout),
              onTap: () {
                // Handle logout
                Navigator.pop(context);
                // Example: Perform logout action and navigate to login screen
              },
            ),
          ],
        ),

      ),

      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'To Do 📝',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                todoHabitsData?.isEmpty==true
                    ? Expanded(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Hello $name ',
                              style: const TextStyle(fontSize: 18, color:Color(AppColor.naviBlue) ),
                            ),
                            const Text(
                              'Use the + button to create some habits!',
                              style: TextStyle(fontSize: 18, color: Colors.grey),
                            ),
                          ],
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: todoHabitsData?.length??0,
                          itemBuilder: (context, index) {
                            Habit habit = todoHabitsData![index];
                            
                            return Dismissible(
                              key: Key(habit.id.toString()),
                              direction: DismissDirection.endToStart,
                              onDismissed: (direction) {
                                // No need to call setState here, _saveHabits will handle it
                                _saveHabits(habit, completed: true);
                              },
                              background: Container(
                                color: Colors.green,
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.symmetric(horizontal: 20),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      'Swipe to Complete',
                                      style: TextStyle(color: Colors.white),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.check, color: Colors.white),
                                  ],
                                ),
                              ),
                              child: _buildHabitCard(habit),
                            );
                          },
                        ),
                      ),
              ],
            ),
          ),
          const Divider(),
          Expanded(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Text(
                    'Done ✅🎉',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                todoHabitsData?.isEmpty==true
                    ? const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Swipe right on an activity to mark as done.',
                          style: TextStyle(fontSize: 16, color: Colors.grey),
                        ),
                      )
                    : Expanded(
                        child: ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                          itemCount: completedHobitData?.length??0,
                    itemBuilder: (context, index) {
                              Habit habit = completedHobitData![index];
                      
                      return Dismissible(
                        key: Key(habit.id.toString()),
                              direction: DismissDirection.startToEnd,
                        onDismissed: (direction) {
                          // No need to call setState here, _saveHabits will handle it
                          _saveHabits(habit, completed: false);
                        },
                        background: Container(
                          color: Colors.red,
                          alignment: Alignment.centerLeft,
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: const Row(
                            children: [
                              Icon(Icons.undo, color: Colors.white),
                              SizedBox(width: 10),
                              Text(
                                'Swipe to Undo',
                                style: TextStyle(color: Colors.white),
                              ),
                            ],
                          ),
                        ),
                              child: _buildHabitCard(habit,),
                      );
                    },
                  ),
                ),              ],
            ),
          ),
        ],
      ),
      floatingActionButton: todoHabitsData?.isEmpty==true
          ? FloatingActionButton(
              onPressed: () {},
              backgroundColor: Colors.blue.shade700,
              tooltip: 'Add Habits',
              child: const Icon(Icons.add,color: Colors.white,),
            )
          : null,
    );
  }

  Widget _buildHabitCard(Habit habit) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      color: Colors.white,
      child: GestureDetector(
        onTap: (){
          Navigator.push(context,MaterialPageRoute(builder: (context) => HabitDetailsScreen(habit)));
        },
        child: Container(
          height: 60, // Adjust the height for thicker cards.
          child: ListTile(
            title: Text(
              habit.title.toUpperCase(),
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            trailing: habit.isCompleted
                ? const Icon(Icons.check_circle, color: Colors.green, size: 28)
                : null,
          ),
        ),
      ),
    );
  }

  Future<void> getSelectedHobits(String username) async {
    final habits = await db.getHabitsForUsername(username);
    if (habits != null) {
      // Assuming 'habits' is a List<Habit>
      setState(() {
        todoHabitsData = habits.where((item)=>item.isCompleted!=true).toList();;
        completedHobitData=habits.where((item)=>item.isCompleted==true).toList();
      });

      print("Habits: $todoHabitsData");
    }
  }
}
