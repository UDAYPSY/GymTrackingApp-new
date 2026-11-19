import 'package:flutter/material.dart';
import '../models/plan_model.dart';
import '../models/member_model.dart';

class AppState extends ChangeNotifier {
  static final AppState instance = AppState._internal();
  factory AppState() => instance;
  AppState._internal() {
    _initializeDefaults();
  }

  // App Settings
  String selectedLanguage = 'English';
  
  // Gym Profile
  String gymName = '';
  String ownerName = '';
  String ownerEmail = '';
  String ownerPhone = '';

  // Setup Progress
  int currentSetupStep = 1; // 1: Add Plan, 2: Add Member, 3: Dashboard

  // Plans & Members
  final List<PlanModel> plans = [];
  final List<MemberModel> members = [];

  void _initializeDefaults() {
    // Seed default sample plan to mirror screenshot
    plans.add(
      const PlanModel(
        id: 'plan_1',
        name: '6 month plan',
        price: 20000,
        durationType: 'Months',
        durationValue: 6,
      ),
    );
  }

  void setLanguage(String lang) {
    selectedLanguage = lang;
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
    currentSetupStep = 2;
    notifyListeners();
  }

  void addMember(MemberModel member) {
    members.add(member);
    currentSetupStep = 3;
    notifyListeners();
  }

  int get nextMembershipId => members.length + 1;
}
