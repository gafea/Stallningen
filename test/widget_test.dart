import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart';

void main() {
  testWidgets('App starts and displays Slivest screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FallGuardApp());
    // Allow platform futures and stream microtasks to process
    await tester.pump(const Duration(seconds: 1));

    // Verify that our app main title is present.
    expect(find.text('Slivest'), findsOneWidget);
  });
}
