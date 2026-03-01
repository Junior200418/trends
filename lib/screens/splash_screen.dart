import 'dart:async';
import 'package:flutter/material.dart';
import 'onboarding_screen.dart';
import 'home_screen.dart';
import '../services/firebase_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatefulWidget {
  static const routeName = '/';

  const SplashScreen({super.key});
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  Future<void> _initApp() async {
    // Initialize Firebase or other services here (non-blocking)
    await FirebaseService.init();

    // Simulate minimal splash delay
    await Future.delayed(Duration(milliseconds: 800));

    final prefs = await SharedPreferences.getInstance();
    final seen = prefs.getBool('onboarding_completed') ?? false;

    if (seen) {
      Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
    } else {
      Navigator.of(context).pushReplacementNamed(OnboardingScreen.routeName);
    }
  }

  @override
  void initState() {
    super.initState();
    _initApp();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // simple branded/logo placeholder
            Icon(Icons.trending_up, size: 84, color: Colors.white),
            SizedBox(height: 16),
            Text('Trends', style: Theme.of(context).textTheme.titleLarge),
          ],
        ),
      ),
    );
  }
}
