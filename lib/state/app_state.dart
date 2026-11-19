import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../models/member_model.dart';

class AttendanceRecord {
  final String id;
  final String memberId;
  final String memberName;
  final DateTime date;
  final String time;

  const AttendanceRecord({
    required this.id,
    required this.memberId,
    required this.memberName,
    required this.date,
    required this.time,
  });
}

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal() {
    _initializeDefaults();
  }

  // App Settings
  String selectedLanguage = 'English';
  String selectedCurrency = '₹ (INR)';
  
  // Gym Profile
  String gymName = 'Raja Bhaiaya';
  String ownerName = 'Ravi';
  String ownerEmail = 'udaypratapsi2022@gmail.com';
  String ownerPhone = '9999746490';
  String gymCode = '18850';

  // Setup Progress
  int currentSetupStep = 1;

  // Plans, Members, Attendance
  final List<PlanModel> plans = [];
  final List<MemberModel> members = [];
  final List<AttendanceRecord> attendanceRecords = [];

  void _initializeDefaults() {
    // Default Plan
    plans.add(
      const PlanModel(
        id: 'plan_1',
        name: '6 month plan',
        price: 20000,
        durationType: 'Months',
        durationValue: 6,
      ),
    );
    plans.add(
      const PlanModel(
        id: 'plan_2',
        name: '1 Year VIP Plan',
        price: 35000,
        durationType: 'Months',
        durationValue: 12,
      ),
    );

    // Default Demo Member so tabs are immediately functional and interactive
    final defaultMember = MemberModel(
      id: 'member_1',
      membershipId: '1',
      name: 'Ravi Kumar',
      phone: '9999746490',
      batch: 'Morning (6:00 AM - 8:00 AM)',
      plan: plans.first,
      planAmount: 20000,
      joiningDate: DateTime(2026, 11, 1),
      paymentDate: DateTime(2026, 11, 1),
      paidAmount: 15000,
      dueAmount: 5000,
      paymentMethod: 'UPI / QR Code',
      paymentReminder: true,
      comments: 'Regular gym enthusiast',
      discountType: 'Percent',
      discountValue: 0,
      admissionFees: 500,
      email: 'udaypratapsi2022@gmail.com',
      dateOfBirth: DateTime(1998, 5, 14),
      address: 'Sector 15, Noida',
      notes: 'Focus on bench press & cardio',
    );
    members.add(defaultMember);

    // Initial Attendance entries for Nov 2026
    attendanceRecords.add(
      AttendanceRecord(
        id: 'att_1',
        memberId: '1',
        memberName: 'Ravi Kumar',
        date: DateTime(2026, 11, 19),
        time: '07:15 AM',
      ),
    );
    attendanceRecords.add(
      AttendanceRecord(
        id: 'att_2',
        memberId: '1',
        memberName: 'Ravi Kumar',
        date: DateTime(2026, 11, 18),
        time: '07:30 AM',
      ),
    );
  }

  void setLanguage(String lang) {
    selectedLanguage = lang;
    notifyListeners();
  }

  void setCurrency(String curr) {
    selectedCurrency = curr;
    notifyListeners();
  }

  void setGymProfile({
    required String name,
    required String owner,
    required String email,
    required String phone,
  }) {
    gymName = name;
    ownerName = owner;
    ownerEmail = email;
    ownerPhone = phone;
    notifyListeners();
  }

  void addPlan(PlanModel plan) {
    plans.add(plan);
    notifyListeners();
  }

  void addMember(MemberModel member) {
    members.add(member);
    notifyListeners();
  }

  void recordAttendance({
    required String memberId,
    required String memberName,
    required DateTime date,
    String time = '07:30 AM',
  }) {
    attendanceRecords.add(
      AttendanceRecord(
        id: 'att_${DateTime.now().millisecondsSinceEpoch}',
        memberId: memberId,
        memberName: memberName,
        date: DateTime(date.year, date.month, date.day),
        time: time,
      ),
    );
    notifyListeners();
  }

  List<AttendanceRecord> getAttendanceForDate(DateTime date) {
    return attendanceRecords.where((a) {
      return a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day;
    }).toList();
  }

  bool hasAttendanceOnDate(DateTime date) {
    return attendanceRecords.any((a) {
      return a.date.year == date.year &&
          a.date.month == date.month &&
          a.date.day == date.day;
    }).toList().isNotEmpty;
  }

  int get nextMembershipId => members.length + 1;
}
