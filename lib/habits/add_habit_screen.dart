import 'package:flutter/material.dart';
import 'package:habit_tracker/services/service.dart';

import '../app_database/app_database.dart';
import '../local_storage.dart';

class AddHabitScreen extends StatefulWidget {
  const AddHabitScreen({super.key});

  @override
  _AddHabitScreenState createState() => _AddHabitScreenState();
}

class _AddHabitScreenState extends State<AddHabitScreen> {

  final DatabaseServices dataService = DatabaseServices();
  final TextEditingController _habitController = TextEditingController();
  Color selectedColor = Colors.amber; // Default color

  final Map<String, Color> _habitColors = {
    'Amber': Colors.amber,
    'Red Accent': Colors.redAccent,
    'Light Blue': Colors.lightBlue,
    'Light Green': Colors.lightGreen,
    'Purple Accent': Colors.purpleAccent,
    'Orange': Colors.orange,
    'Teal': Colors.teal,
    'Deep Purple': Colors.deepPurple,
  };
  String selectedColorName = 'Amber'; // Default color name

  List<Habit>? selectedHabitsMap;
  List<Habit>? completedHabitsMap;

  String? userName='';

  List<Habit>? allHabitsMap;

  int userId=-1;

  @override
  void initState() {
    super.initState();
    userName=LocalStorage().getUsername()??'';
    userId=LocalStorage().getUserID()??-1;
    _loadHabits();
  }



  Future<void> _loadHabits() async {


    final habits = await dataService.getHabitById(userId);
    if (habits != null) {
      // Assuming 'habits' is a List<Habit>
      setState(() {
        allHabitsMap=habits;
        selectedHabitsMap = habits.where((item)=>item.isCompleted!=true).toList();;
        completedHabitsMap=habits.where((item)=>item.isCompleted==true).toList();
      });


    }
  }
  Future<void> _saveHabits() async {
    // This function intentionally left empty as no saving is needed
  }

  @override
  Widget build(BuildContext context) {
    // Combine both maps for display, ensuring no duplicates


    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade700,
        title: Text('Configure Habits',style: TextStyle( color: Colors.white,fontSize: 16 ),),
        leading: IconButton(onPressed: (){
          Navigator.pop(context);
        }, icon: Icon(Icons.arrow_back,color: Colors.white,)),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: _habitController,
              decoration: const InputDecoration(
                labelText: 'Habit Name',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Select Color:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey),
              ),
              child: DropdownButton<String>(
                value: selectedColorName,
                isExpanded: true,
                underline: const SizedBox(),
                items: _habitColors.keys.map((String colorName) {
                  return DropdownMenuItem<String>(
                    value: colorName,
                    child: Container(
                      height: 40,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: _habitColors[colorName],
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: Text(
                        colorName,
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selectedColorName = newValue!;
                    selectedColor = _habitColors[selectedColorName]!;
                  });
                },
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _addHabit();
              },
              child: Text(
                'Add Habit',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade700,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: allHabitsMap != null
                    ? allHabitsMap!.map((habit) {
                        final habitName = habit.title;
                        // Assuming you have a way to get color for the habit
                        // For now, using a placeholder color
                        final habitColor = _habitColors[habit.color]!; // Placeholder
                        return ListTile(
                          leading: CircleAvatar(
                            backgroundColor: habitColor,
                          ),
                          title: Text(habitName),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () async {
                              // Remove habit from the database
                              await dataService.deleteHabitById(habit.id);
                              // Reload habits from the database to reflect changes
                              setState(() {
                                _loadHabits();
                              });
                            },
                          ),
                        );
                      }).toList()
                    : [], // Return an empty list if allHabitsMap is null
              ),            ),
          ],
        ),
      ),
    );
  }

  Future<void> _addHabit() async {
    if (_habitController.text.isNotEmpty) {
      final habitName = _habitController.text;
      final habitColorHex = selectedColor.value.toRadixString(16);

      // Check for duplicates
      if (allHabitsMap!.any((habit) => habit.title.trim() == habitName.trim())) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Habit "$habitName" already exists.')),
        );
        return;
      }


      await dataService.insertHobby(
        userId: userId,
        title: habitName,
        color: selectedColorName,
      );


      setState(() {
        _loadHabits();
        _habitController.clear();
        selectedColorName = 'Amber'; // Reset to default
        selectedColor = _habitColors[selectedColorName]!;
      });
    }
  }

  Color _getColorFromHex(String hexColor) {
    hexColor = hexColor.replaceAll('#', '');
    if (hexColor.length == 6) {
      hexColor = 'FF$hexColor'; // Add opacity if not included.
    }
    return Color(int.parse('0x$hexColor'));
  }
}