// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:surgo/main.dart';

void main() {
  testWidgets('SurGo splash screen shows the brand and tagline',
      (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const SurGoApp());

    // The splash screen renders the SurGo wordmark (as a single RichText
    // made of the 'SUR' + 'GO' spans) and the tagline below it.
    expect(find.text('SURGO'), findsOneWidget);
    expect(find.text('Ride. Rent. Go.'), findsOneWidget);
  });
}
