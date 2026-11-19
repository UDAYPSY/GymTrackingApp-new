import 'package:flutter_test/flutter_test.dart';
import 'package:track_my_gym/main.dart';

void main() {
  testWidgets('TrackMyGym smoke test and screen title verification', (WidgetTester tester) async {
    await tester.pumpWidget(const TrackMyGymApp());
    expect(find.text('TrackMyGym'), findsOneWidget);
    expect(find.text('All-in-one gym management.'), findsOneWidget);
    expect(find.text('Log in or sign up'), findsOneWidget);
  });
}
