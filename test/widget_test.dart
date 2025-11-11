// Basic Flutter widget test for ScoutMena app
//
// This test verifies that the app launches correctly and shows the welcome screen.

//import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:scoutmena_app/main.dart';

void main() {
  testWidgets('App launches and shows welcome screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const ScoutMenaApp());

    // Verify that the app shows welcome text
    expect(find.text('ScoutMena'), findsWidgets);

    // Verify Phase 1 Complete badge is shown
    expect(find.text('Phase 1 Complete'), findsOneWidget);
  });
}
