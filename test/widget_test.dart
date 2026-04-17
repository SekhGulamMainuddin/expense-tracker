import 'package:flutter_test/flutter_test.dart';
import 'package:expense_tracker/core/init_app.dart';
import 'package:expense_tracker/core/main_app.dart';

void main() {
  testWidgets('renders expense tracker starter screen', (
    WidgetTester tester,
  ) async {
    await initApp();
    await tester.pumpWidget(const MainApp());
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('Expense Tracker'), findsOneWidget);
    expect(find.text('Track every rupee with clarity'), findsOneWidget);
  });
}
