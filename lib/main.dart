// ...existing code...
import 'package:flutter/material.dart';
import 'constants/theme.dart';
import 'screens/splash_screen.dart';
import 'screens/onboarding_screen.dart';
import 'screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const TrendsApp());
}

class TrendsApp extends StatelessWidget {
  const TrendsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Trends',
      debugShowCheckedModeBanner: false,
      theme: buildDarkTheme(),
      initialRoute: SplashScreen.routeName,
      routes: {
        SplashScreen.routeName: (_) => const SplashScreen(),
        OnboardingScreen.routeName: (_) => const OnboardingScreen(),
        HomeScreen.routeName: (_) => const HomeScreen(),
      },
    );
  }
}
// ...existing code...