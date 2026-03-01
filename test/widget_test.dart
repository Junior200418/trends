// ...existing code...
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:trends/main.dart';

void main() {
  testWidgets('Smoke test - app boots', (WidgetTester tester) async {
    await tester.pumpWidget(const TrendsApp());
    await tester.pumpAndSettle();
    expect(find.text('Trends'), findsOneWidget);
  });
}
// ...existing code...