import 'plan_model.dart';

class MemberModel {
  final String id;
  final String membershipId;
  final String? name;
  final String? phone;
  final String batch;
  final PlanModel plan;
  final double planAmount;
  final DateTime joiningDate;
  final DateTime paymentDate;
  final double paidAmount;
  final double dueAmount;
  final String paymentMethod;
  final bool paymentReminder;
  final DateTime? reminderDateTime;
  final String comments;
  final String discountType; // 'Percent' or 'Amount'
  final double discountValue;
  final double admissionFees;
  final String email;
  final DateTime? dateOfBirth;
  final String address;
  final String notes;
  final String status; // 'Active', 'Pending', 'Expired'

  const MemberModel({
    required this.id,
    required this.membershipId,
    this.name,
    this.phone,
    required this.batch,
    required this.plan,
    required this.planAmount,
    required this.joiningDate,
    required this.paymentDate,
    required this.paidAmount,
    required this.dueAmount,
    required this.paymentMethod,
    this.paymentReminder = false,
    this.reminderDateTime,
    this.comments = '',
    this.discountType = 'Percent',
    this.discountValue = 0.0,
    this.admissionFees = 0.0,
    this.email = '',
    this.dateOfBirth,
    this.address = '',
    this.notes = '',
    this.status = 'Active',
  });

  bool get isPaidFull => dueAmount <= 0;
}
