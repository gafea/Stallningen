import 'package:flutter_test/flutter_test.dart';
import 'package:demo/main.dart';

void main() {
  testWidgets('App starts and displays Stallningen AI screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const FallGuardApp());

    // Verify that our app main title is present.
    expect(find.text('Stallningen AI'), findsOneWidget);
  });
}
