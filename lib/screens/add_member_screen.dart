import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../theme/app_colors.dart';
import '../models/plan_model.dart';
import '../models/member_model.dart';
import '../state/app_state.dart';
import 'dashboard_screen.dart';

class AddMemberScreen extends StatefulWidget {
  const AddMemberScreen({super.key});

  @override
  State<AddMemberScreen> createState() => _AddMemberScreenState();
}

class _AddMemberScreenState extends State<AddMemberScreen> {
  final _formKey = GlobalKey<FormState>();

  // Controllers
  late final TextEditingController _membershipIdController;
  final TextEditingController _batchController =
      TextEditingController(text: 'No Batch Found');
  final TextEditingController _paidAmountController = TextEditingController(text: '0');
  final TextEditingController _commentsController = TextEditingController();
  final TextEditingController _discountController = TextEditingController(text: '0');
  final TextEditingController _admissionFeesController =
      TextEditingController(text: '0');
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _notesController = TextEditingController();

  // State
  late PlanModel _selectedPlan;
  DateTime _joiningDate = DateTime.now();
  DateTime _paymentDate = DateTime.now();
  DateTime? _dob;
  String _paymentMethod = 'Select Payment Method';
  bool _paymentReminder = false;
  DateTime? _reminderDateTime;
  String _discountType = 'Percent'; // 'Percent' or 'Amount'

  final List<String> _paymentMethods = const [
    'Select Payment Method',
    'Cash',
    'UPI / QR Code',
    'Debit / Credit Card',
    'Net Banking',
  ];

  @override
  void initState() {
    super.initState();
    final appState = AppState.instance;
    _membershipIdController =
        TextEditingController(text: appState.nextMembershipId.toString());

    _selectedPlan = appState.plans.isNotEmpty
        ? appState.plans.last
        : const PlanModel(
            id: 'default_plan',
            name: '6 month plan',
            price: 20000,
            durationType: 'Months',
            durationValue: 6,
          );
  }

  @override
  void dispose() {
    _membershipIdController.dispose();
    _batchController.dispose();
    _paidAmountController.dispose();
    _commentsController.dispose();
    _discountController.dispose();
    _admissionFeesController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  double get _calculatedDueAmount {
    final planAmount = _selectedPlan.price;
    final paid = double.tryParse(_paidAmountController.text) ?? 0.0;
    final discountVal = double.tryParse(_discountController.text) ?? 0.0;
    final admission = double.tryParse(_admissionFeesController.text) ?? 0.0;

    double discountTotal = 0;
    if (_discountType == 'Percent') {
      discountTotal = (planAmount * (discountVal / 100));
    } else {
      discountTotal = discountVal;
    }

    final totalToPay = (planAmount - discountTotal) + admission;
    final due = totalToPay - paid;
    return due < 0 ? 0 : due;
  }

  Future<void> _pickDate({
    required BuildContext context,
    required DateTime initialDate,
    required Function(DateTime) onPicked,
  }) async {
    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: DateTime(1950),
      lastDate: DateTime(2035),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: AppColors.primaryTeal,
              onPrimary: Colors.white,
              onSurface: AppColors.textPrimary,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() => onPicked(picked));
    }
  }

  void _onSaveMember() {
    final paid = double.tryParse(_paidAmountController.text) ?? 0.0;
    final discountVal = double.tryParse(_discountController.text) ?? 0.0;
    final admission = double.tryParse(_admissionFeesController.text) ?? 0.0;

    final newMember = MemberModel(
      id: 'member_${DateTime.now().millisecondsSinceEpoch}',
      membershipId: _membershipIdController.text.trim(),
      batch: _batchController.text.trim(),
      plan: _selectedPlan,
      planAmount: _selectedPlan.price,
      joiningDate: _joiningDate,
      paymentDate: _paymentDate,
      paidAmount: paid,
      dueAmount: _calculatedDueAmount,
      paymentMethod: _paymentMethod,
      paymentReminder: _paymentReminder,
      reminderDateTime: _reminderDateTime,
      comments: _commentsController.text.trim(),
      discountType: _discountType,
      discountValue: discountVal,
      admissionFees: admission,
      email: _emailController.text.trim(),
      dateOfBirth: _dob,
      address: _addressController.text.trim(),
      notes: _notesController.text.trim(),
    );

    AppState.instance.addMember(newMember);

    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute(builder: (ctx) => const DashboardScreen()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final dateFormat = DateFormat('dd/MM/yyyy');
    final availablePlans = AppState.instance.plans;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.primaryTeal,
        elevation: 0,
        title: const Text(
          'Add Member',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      // Top Card: Membership ID & Batch
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Membership ID
                            TextFormField(
                              controller: _membershipIdController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Membership ID',
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: AppColors.successGreen,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            const Padding(
                              padding: EdgeInsets.only(left: 4),
                              child: Text(
                                'Membership ID is available',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.successGreen,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Batch / Group Class
                            TextFormField(
                              controller: _batchController,
                              decoration: const InputDecoration(
                                labelText: 'Batch / Group Class',
                                prefixIcon: Icon(
                                  Icons.groups_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Plan Details Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Plan Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Select Gym Plan Dropdown
                            DropdownButtonFormField<PlanModel>(
                              value: availablePlans.contains(_selectedPlan)
                                  ? _selectedPlan
                                  : (availablePlans.isNotEmpty
                                      ? availablePlans.first
                                      : null),
                              decoration: const InputDecoration(
                                labelText: 'Select Gym Plan',
                                prefixIcon: Icon(
                                  Icons.assignment_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              items: availablePlans.map((plan) {
                                return DropdownMenuItem<PlanModel>(
                                  value: plan,
                                  child: Text(
                                    '${plan.name} (${plan.price.toStringAsFixed(0)})',
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (plan) {
                                if (plan != null) {
                                  setState(() => _selectedPlan = plan);
                                }
                              },
                            ),

                            const SizedBox(height: 12),

                            // Plan Amount Label
                            Text(
                              'Plan Amount: ₹${NumberFormat('#,##,###').format(_selectedPlan.price)}',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Select Joining Date Picker
                            InkWell(
                              onTap: () => _pickDate(
                                context: context,
                                initialDate: _joiningDate,
                                onPicked: (d) => _joiningDate = d,
                              ),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Select Joining Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                                child: Text(
                                  dateFormat.format(_joiningDate),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Payment Date Picker
                            InkWell(
                              onTap: () => _pickDate(
                                context: context,
                                initialDate: _paymentDate,
                                onPicked: (d) => _paymentDate = d,
                              ),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Payment Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                                child: Text(
                                  dateFormat.format(_paymentDate),
                                  style: const TextStyle(fontSize: 14),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Paid Amount
                            TextFormField(
                              controller: _paidAmountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Paid Amount',
                                prefixIcon: Icon(
                                  Icons.payments_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Payment Method Dropdown
                            DropdownButtonFormField<String>(
                              value: _paymentMethod,
                              decoration: const InputDecoration(
                                labelText: 'Payment Method',
                                prefixIcon: Icon(
                                  Icons.credit_card_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              items: _paymentMethods.map((method) {
                                return DropdownMenuItem<String>(
                                  value: method,
                                  child: Text(
                                    method,
                                    style: const TextStyle(fontSize: 14),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _paymentMethod = val);
                                }
                              },
                            ),

                            const SizedBox(height: 12),

                            // Due Amount
                            Text(
                              'Due Amount: ₹${NumberFormat('#,##,###').format(_calculatedDueAmount)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: _calculatedDueAmount > 0
                                    ? AppColors.warningOrange
                                    : AppColors.successGreen,
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Payment Reminder Toggle Container
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 10,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(10),
                                border: Border.all(color: AppColors.borderLight),
                              ),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: const [
                                        Text(
                                          'Payment reminder',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: AppColors.textPrimary,
                                          ),
                                        ),
                                        SizedBox(height: 2),
                                        Text(
                                          'Choose a date and time.',
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: AppColors.textSecondary,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Switch(
                                    value: _paymentReminder,
                                    activeColor: AppColors.primaryTeal,
                                    onChanged: (val) {
                                      setState(() => _paymentReminder = val);
                                    },
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Comments
                            TextFormField(
                              controller: _commentsController,
                              decoration: const InputDecoration(
                                labelText: 'Comments',
                                prefixIcon: Icon(
                                  Icons.chat_bubble_outline,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 18),

                            // Discount in Plan Section
                            const Text(
                              'Discount in Plan:',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Row(
                              children: [
                                const Icon(
                                  Icons.local_offer_outlined,
                                  color: AppColors.primaryTeal,
                                  size: 18,
                                ),
                                const SizedBox(width: 8),
                                Radio<String>(
                                  value: 'Percent',
                                  groupValue: _discountType,
                                  activeColor: AppColors.primaryTeal,
                                  onChanged: (val) {
                                    setState(() => _discountType = val!);
                                  },
                                ),
                                const Text('Percent', style: TextStyle(fontSize: 13)),
                                const SizedBox(width: 14),
                                Radio<String>(
                                  value: 'Amount',
                                  groupValue: _discountType,
                                  activeColor: AppColors.primaryTeal,
                                  onChanged: (val) {
                                    setState(() => _discountType = val!);
                                  },
                                ),
                                const Text('Amount', style: TextStyle(fontSize: 13)),
                              ],
                            ),

                            const SizedBox(height: 10),

                            // Discount Input
                            TextFormField(
                              controller: _discountController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Discount',
                                prefixIcon: Icon(
                                  Icons.verified_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Admission Fees
                            TextFormField(
                              controller: _admissionFeesController,
                              keyboardType: TextInputType.number,
                              onChanged: (_) => setState(() {}),
                              decoration: const InputDecoration(
                                labelText: 'Admission Fees',
                                prefixIcon: Icon(
                                  Icons.fitness_center,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Member Details Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.03),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Member Details',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 14),

                            // Email
                            TextFormField(
                              controller: _emailController,
                              keyboardType: TextInputType.emailAddress,
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(
                                  Icons.email_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Date of Birth
                            InkWell(
                              onTap: () => _pickDate(
                                context: context,
                                initialDate: _dob ?? DateTime(2000, 1, 1),
                                onPicked: (d) => _dob = d,
                              ),
                              child: InputDecorator(
                                decoration: const InputDecoration(
                                  labelText: 'Date of Birth',
                                  prefixIcon: Icon(
                                    Icons.cake_outlined,
                                    color: AppColors.primaryTeal,
                                  ),
                                ),
                                child: Text(
                                  _dob == null
                                      ? 'Select Date of Birth'
                                      : dateFormat.format(_dob!),
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: _dob == null
                                        ? AppColors.textMuted
                                        : AppColors.textPrimary,
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Address
                            TextFormField(
                              controller: _addressController,
                              decoration: const InputDecoration(
                                labelText: 'Address',
                                prefixIcon: Icon(
                                  Icons.home_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),

                            const SizedBox(height: 14),

                            // Notes
                            TextFormField(
                              controller: _notesController,
                              maxLines: 2,
                              decoration: const InputDecoration(
                                labelText: 'Notes',
                                prefixIcon: Icon(
                                  Icons.assignment_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Fixed Save Button
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, -1),
                  ),
                ],
              ),
              child: SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  onPressed: _onSaveMember,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
