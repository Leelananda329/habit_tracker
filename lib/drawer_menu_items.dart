
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/personal_info_screen.dart';
import 'package:habit_tracker/reports_screen.dart';

import 'constants/app_constants.dart';
import 'habits/add_habit_screen.dart';
import 'local_storage.dart';
import 'login_screen.dart';
import 'notificatons_screen.dart';

class DrawerMenuItems extends StatelessWidget {
  final Future<void> Function() getSelectedHobits;
  const DrawerMenuItems({super.key, required this.getSelectedHobits});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
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
          leading: const Icon(Icons.settings),
          title: const Text('Configure'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const AddHabitScreen(),
              ),
            ).then((updatedHabits) {
              getSelectedHobits(); // Reload data after returning
            });
          },
        ),
        ListTile(
          leading: const Icon(Icons.person),
          title: const Text(AppConstants.personalInfo),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const PersonalInfoScreen()))
                .then((updatedHabits) {
              getSelectedHobits(); // Reload data after returning
            });

          },
        ),
        ListTile(
          leading: const Icon(Icons.analytics),
          title: const Text('Reports'),
          onTap: () {
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>const ReportsScreen()))
                .then((updatedHabits) {
              getSelectedHobits(); // Reload data after returning
            });;

          },
        ),
        ListTile(
          leading: const Icon(Icons.notifications),
          title: const Text('Notifications'),
          onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>NotificationsScreen()));
          },
        ),
        ListTile(
          leading: const Icon(Icons.logout),
          title: const Text('Sign Out'),
          onTap: (){
            _signOut(context);
          },

        ),
      ],
    );
  }

  void _signOut(BuildContext context) async {

    await LocalStorage().clear();

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

}
