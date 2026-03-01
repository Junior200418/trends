// ...existing code...
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  static const routeName = '/onboarding';
  const OnboardingScreen({Key? key}) : super(key: key);

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pc = PageController();

  Future<void> _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);
    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    final styleTitle = const TextStyle(
      fontSize: 22,
      fontWeight: FontWeight.bold,
      color: Colors.white,
    );
    final styleBody = const TextStyle(fontSize: 16, color: Colors.white70);

    return Scaffold(
      body: SafeArea(
        child: PageView(
          controller: _pc,
          children: [
            _slide(
              title: 'What Trends does.',
              body: 'Full-screen vertical trend feed with quick insights.',
              styleTitle: styleTitle,
              styleBody: styleBody,
            ),
            _slide(
              title: 'How to navigate',
              body: 'Vertical = next trend. Horizontal = details.',
              styleTitle: styleTitle,
              styleBody: styleBody,
            ),
            _slide(
              title: 'Why it matters',
              body: 'Fast macro & market updates for quick decision making.',
              styleTitle: styleTitle,
              styleBody: styleBody,
              action: ElevatedButton(
                onPressed: _completeOnboarding,
                child: const Text('Enter App'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _slide({
    required String title,
    required String body,
    required TextStyle styleTitle,
    required TextStyle styleBody,
    Widget? action,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Text(title, style: styleTitle, textAlign: TextAlign.center),
          const SizedBox(height: 20),
          Text(body, style: styleBody, textAlign: TextAlign.center),
          const Spacer(),
          if (action != null) action,
        ],
      ),
    );
  }
}
// ...existing code...