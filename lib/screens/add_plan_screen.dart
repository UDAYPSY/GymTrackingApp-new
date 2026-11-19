import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/stepper_header.dart';
import '../models/plan_model.dart';
import '../state/app_state.dart';
import 'add_member_screen.dart';

class AddPlanScreen extends StatefulWidget {
  const AddPlanScreen({super.key});

  @override
  State<AddPlanScreen> createState() => _AddPlanScreenState();
}

class _AddPlanScreenState extends State<AddPlanScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  bool _fillTestData = false;
  String _durationType = 'Months'; // 'Months' or 'Days'
  int _selectedDuration = 1;

  final List<int> _monthOptions = const [1, 2, 3, 6, 12];
  final List<int> _dayOptions = const [15, 30, 45, 60, 90, 180, 365];

  @override
  void dispose() {
    _nameController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _onToggleTestData(bool value) {
    setState(() {
      _fillTestData = value;
      if (value) {
        _nameController.text = '6 Month Premium';
        _priceController.text = '20000';
        _durationType = 'Months';
        _selectedDuration = 6;
      } else {
        _nameController.clear();
        _priceController.clear();
        _selectedDuration = 1;
      }
    });
  }

  void _onSavePlan() {
    if (_formKey.currentState?.validate() ?? false) {
      final newPlan = PlanModel(
        id: 'plan_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        price: double.tryParse(_priceController.text.trim()) ?? 0.0,
        durationType: _durationType,
        durationValue: _selectedDuration,
      );

      AppState.instance.addPlan(newPlan);

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AddMemberScreen(),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      appBar: AppBar(
        backgroundColor: AppColors.primaryTeal,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          'Add Plan',
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
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Stepper Progress Header
                    const StepperHeader(currentStep: 1),

                    const SizedBox(height: 16),

                    // Light cyan banner "Add a Plan"
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: AppColors.bannerBackground,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Add a Plan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                          const SizedBox(height: 4),
                          const Text(
                            'Create at least one membership plan so you can add members to it later.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                              height: 1.3,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Row(
                            children: [
                              Switch(
                                value: _fillTestData,
                                activeColor: AppColors.primaryTeal,
                                onChanged: _onToggleTestData,
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: const [
                                    Text(
                                      'Fill Test Data',
                                      style: TextStyle(
                                        fontSize: 13,
                                        fontWeight: FontWeight.bold,
                                        color: AppColors.primaryTeal,
                                      ),
                                    ),
                                    Text(
                                      'Use sample data to explore the app.',
                                      style: TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textSecondary,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 18),

                    // Gym Plan Creation Instructions
                    const Text(
                      'Gym Plan Creation Instructions',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    _buildInstructionItem(
                      '1. Set plan name and price',
                      'Example: "6 Month Premium" - 5000',
                    ),
                    _buildInstructionItem(
                      '2. Choose duration in months or days',
                      'Example: 6 months or 180 days',
                    ),
                    _buildInstructionItem(
                      '3. These plans will be assigned to gym members',
                      'Example: Assign "6 Month Premium" to new members',
                    ),

                    const SizedBox(height: 16),

                    // Form Card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.03),
                            blurRadius: 8,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Plan Name
                            TextFormField(
                              controller: _nameController,
                              decoration: const InputDecoration(
                                labelText: 'Plan Name *',
                                prefixIcon: Icon(
                                  Icons.badge_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Please enter plan name'
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            // Price
                            TextFormField(
                              controller: _priceController,
                              keyboardType: TextInputType.number,
                              decoration: const InputDecoration(
                                labelText: 'Price *',
                                prefixIcon: Icon(
                                  Icons.payments_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              validator: (v) => v == null || v.trim().isEmpty
                                  ? 'Please enter price'
                                  : null,
                            ),

                            const SizedBox(height: 14),

                            // Duration Type Radio (Months / Days)
                            Row(
                              children: [
                                const Icon(
                                  Icons.calendar_today_outlined,
                                  color: AppColors.primaryTeal,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Radio<String>(
                                  value: 'Months',
                                  groupValue: _durationType,
                                  activeColor: AppColors.primaryTeal,
                                  onChanged: (val) {
                                    setState(() {
                                      _durationType = val!;
                                      _selectedDuration = 1;
                                    });
                                  },
                                ),
                                const Text('Months', style: TextStyle(fontSize: 14)),
                                const SizedBox(width: 16),
                                Radio<String>(
                                  value: 'Days',
                                  groupValue: _durationType,
                                  activeColor: AppColors.primaryTeal,
                                  onChanged: (val) {
                                    setState(() {
                                      _durationType = val!;
                                      _selectedDuration = 30;
                                    });
                                  },
                                ),
                                const Text('Days', style: TextStyle(fontSize: 14)),
                              ],
                            ),

                            const SizedBox(height: 12),

                            // Select Plan Duration Dropdown
                            DropdownButtonFormField<int>(
                              value: _selectedDuration,
                              decoration: const InputDecoration(
                                labelText: 'Select Plan Duration',
                                prefixIcon: Icon(
                                  Icons.access_time_outlined,
                                  color: AppColors.primaryTeal,
                                ),
                              ),
                              items: (_durationType == 'Months'
                                      ? _monthOptions
                                      : _dayOptions)
                                  .map((duration) {
                                return DropdownMenuItem<int>(
                                  value: duration,
                                  child: Text(
                                    '$duration ${_durationType == 'Months' ? (duration == 1 ? 'Month' : 'Months') : 'Days'}',
                                    style: const TextStyle(
                                      fontSize: 14,
                                      color: AppColors.textPrimary,
                                    ),
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() {
                                    _selectedDuration = val;
                                  });
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 20),
                  ],
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
                  onPressed: _onSavePlan,
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

  Widget _buildInstructionItem(String title, String example) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            example,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
