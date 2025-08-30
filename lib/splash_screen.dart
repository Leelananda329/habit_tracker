
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:habit_tracker/habits/habit_tracker_screen.dart';
import 'package:habit_tracker/login_screen.dart';

import 'local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}


class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {

  late AnimationController _controller;
  late Animation<double> _animation;

  bool isSignIn=false;
  @override
  void initState() {

    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: 2),
    );

    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );

    _controller.forward();

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        isSignIn=LocalStorage().getIsSignIn()??false;

        if(isSignIn) {
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>HabitTrackerScreen()));
        }else{
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));

        }
      }
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: FadeTransition(
          opacity: _animation,
          child: ScaleTransition(
            scale: _animation,
            child: Image.asset(
              'assets/icon/habit_icon.png', // Replace with your habit icon path
              width: 150,
              height: 150,
            ),
          ),
        ),
      ),
    );
  }
}
