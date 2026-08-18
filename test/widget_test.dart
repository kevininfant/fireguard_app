import 'package:flutter_test/flutter_test.dart';
import 'package:fireguard_app/app.dart';

void main() {
  testWidgets('FireGuard app smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FireGuardApp());
    await tester.pump(const Duration(milliseconds: 100));
    await tester.pump(const Duration(seconds: 3));
    expect(find.byType(FireGuardApp), findsOneWidget);
  });
}
