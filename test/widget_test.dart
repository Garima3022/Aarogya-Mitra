import 'package:flutter_test/flutter_test.dart';
import 'package:sehat_vision/main.dart';

void main() {
  testWidgets('App launches smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SehatVisionApp());
    expect(find.text('SEHAT VISION'), findsWidgets);
  });
}
