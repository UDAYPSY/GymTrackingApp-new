import 'package:flutter_test/flutter_test.dart';
import 'package:track_my_gym/main.dart';
import 'package:track_my_gym/models/plan_model.dart';
import 'package:track_my_gym/models/member_model.dart';
import 'package:track_my_gym/state/app_state.dart';
import 'package:track_my_gym/screens/onboarding_screen.dart';

void main() {
  group('Data Models & Business Logic Tests', () {
    test('PlanModel instantiates correctly with calculation helpers', () {
      const plan = PlanModel(
        id: 'plan_1',
        name: '6 Month Membership',
        price: 20000,
        durationType: 'Months',
        durationValue: 6,
      );

      expect(plan.name, '6 Month Membership');
      expect(plan.price, 20000.0);
      expect(plan.durationValue, 6);
      expect(plan.displayName, '6 Month Membership (₹20000)');
      expect(plan.durationString, '6 Months');

      final map = plan.toMap();
      final reconstructed = PlanModel.fromMap(map);
      expect(reconstructed.id, plan.id);
      expect(reconstructed.name, plan.name);
      expect(reconstructed.price, plan.price);
    });

    test('MemberModel calculates full payment status correctly', () {
      final paidMember = MemberModel(
        id: 'm1',
        membershipId: '1',
        name: 'John Doe',
        batch: 'Morning',
        plan: const PlanModel(id: 'p1', name: 'Plan', price: 1000),
        planAmount: 1000,
        joiningDate: DateTime(2026, 1, 1),
        paymentDate: DateTime(2026, 1, 1),
        paidAmount: 1000,
        dueAmount: 0,
        paymentMethod: 'Cash',
      );
      expect(paidMember.isPaidFull, true);

      final dueMember = MemberModel(
        id: 'm2',
        membershipId: '2',
        name: 'Jane Doe',
        batch: 'Evening',
        plan: const PlanModel(id: 'p1', name: 'Plan', price: 1000),
        planAmount: 1000,
        joiningDate: DateTime(2026, 1, 1),
        paymentDate: DateTime(2026, 1, 1),
        paidAmount: 400,
        dueAmount: 600,
        paymentMethod: 'UPI',
      );
      expect(dueMember.isPaidFull, false);
      expect(dueMember.dueAmount, 600);
    });

    test('AppState singleton manages gym profile and collections', () {
      final state = AppState.instance;
      expect(state.plans.isNotEmpty, true);
      expect(state.selectedLanguage, isNotEmpty);
      expect(state.selectedCurrency, isNotEmpty);

      state.setGymProfile(
        name: 'TrackMyGym HQ',
        owner: 'Owner Test',
        email: 'test@trackmygym.com',
        phone: '9999999999',
      );
      expect(state.gymName, 'TrackMyGym HQ');
      expect(state.ownerName, 'Owner Test');
    });
  });

  group('Widget Smoke Tests', () {
    testWidgets('TrackMyGymApp mounts OnboardingScreen successfully', (WidgetTester tester) async {
      await tester.pumpWidget(const TrackMyGymApp());
      expect(find.byType(TrackMyGymApp), findsOneWidget);
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });
  });
}
