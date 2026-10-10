import 'package:flutter_test/flutter_test.dart';

import 'package:workoutkit_example/main.dart';

void main() {
  testWidgets('shows the example tabs', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('Preview'), findsOneWidget);
    expect(find.text('Validate'), findsOneWidget);
    expect(find.text('Customize'), findsOneWidget);
    expect(find.text('Schedule'), findsOneWidget);
  });
}
