// ...existing code...
import 'package:flutter/material.dart';

ThemeData buildDarkTheme() {
  final base = ThemeData.dark();
  return base.copyWith(
    scaffoldBackgroundColor: const Color(0xFF0F1113), // deep charcoal
    primaryColor: Colors.white,
    colorScheme: base.colorScheme.copyWith(secondary: Colors.blueAccent),
    textTheme: base.textTheme.apply(
      bodyColor: Colors.white,
      displayColor: Colors.white,
    ),
    iconTheme: const IconThemeData(color: Colors.white70),
  );
}
