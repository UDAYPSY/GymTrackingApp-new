import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../widgets/language_selector_sheet.dart';
import '../state/app_state.dart';
import 'add_plan_screen.dart';
import 'support_center_screen.dart';

class SignUpScreen extends StatefulWidget {
  final String initialEmail;

  const SignUpScreen({
    Key? key,
    this.initialEmail = '',
  }) : super(key: key);

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _gymNameController;
  late final TextEditingController _yourNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  final TextEditingController _referralController = TextEditingController();

  bool _applyReferral = false;
  bool _obscurePassword = true;

  @override
  void initState() {
    super.initState();
    _gymNameController = TextEditingController(text: 'Raja Bhaiaya');
    _yourNameController = TextEditingController(text: 'Ravi');
    _phoneController = TextEditingController(text: '9999746490');
    _emailController = TextEditingController(
      text: widget.initialEmail.isNotEmpty
          ? widget.initialEmail
          : 'udaypratapsi2022@gmail.com',
    );
    _passwordController = TextEditingController(text: 'password123');
  }

  void _onSignUp() {
    if (_formKey.currentState?.validate() ?? false) {
      AppState.instance.setGymProfile(
        name: _gymNameController.text.trim(),
        owner: _yourNameController.text.trim(),
        email: _emailController.text.trim(),
        phone: _phoneController.text.trim(),
      );

      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (ctx) => const AddPlanScreen(),
        ),
      );
    }
  }

  void _openLanguageSettings() async {
    final newLang = await LanguageSelectorSheet.show(context);
    if (newLang != null) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentLanguage = AppState.instance.selectedLanguage;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header curved banner
              Container(
                width: double.infinity,
                height: 110,
                decoration: const BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.circular(28),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Back button & Title
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: AppColors.borderLight),
                        ),
                        child: const Icon(
                          Icons.chevron_left,
                          color: AppColors.textPrimary,
                          size: 22,
                        ),
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: const [
                          Text(
                            'TrackMyGym',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'All-in-one gym management.',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 40), // Balance back button
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // "Sign up" Divider
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  children: [
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 14),
                      child: Text(
                        'Sign up',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                    Expanded(child: Divider(color: Colors.grey.shade300)),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Form fields
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      // Gym Name
                      TextFormField(
                        controller: _gymNameController,
                        decoration: const InputDecoration(
                          labelText: 'Gym Name',
                          prefixIcon: Icon(
                            Icons.apartment,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 14),

                      // Your Name
                      TextFormField(
                        controller: _yourNameController,
                        decoration: const InputDecoration(
                          labelText: 'Your Name',
                          prefixIcon: Icon(
                            Icons.person,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 14),

                      // Phone (+91 selector + number)
                      Row(
                        children: [
                          Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: const [
                                Text('🇮🇳', style: TextStyle(fontSize: 18)),
                                SizedBox(width: 6),
                                Text(
                                  '+91',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14,
                                    color: AppColors.textPrimary,
                                  ),
                                ),
                                Icon(
                                  Icons.keyboard_arrow_down,
                                  color: AppColors.textSecondary,
                                  size: 18,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: TextFormField(
                              controller: _phoneController,
                              keyboardType: TextInputType.phone,
                              decoration: const InputDecoration(
                                hintText: 'Phone number',
                              ),
                              validator: (v) =>
                                  v == null || v.trim().isEmpty ? 'Required' : null,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Email Address
                      TextFormField(
                        controller: _emailController,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email Address',
                          prefixIcon: Icon(
                            Icons.email_outlined,
                            color: AppColors.primaryTeal,
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.trim().isEmpty ? 'Required' : null,
                      ),

                      const SizedBox(height: 14),

                      // Password
                      TextFormField(
                        controller: _passwordController,
                        obscureText: _obscurePassword,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          prefixIcon: const Icon(
                            Icons.vpn_key_outlined,
                            color: AppColors.primaryTeal,
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _obscurePassword
                                  ? Icons.visibility_off_outlined
                                  : Icons.visibility_outlined,
                              color: AppColors.textSecondary,
                            ),
                            onPressed: () {
                              setState(() {
                                _obscurePassword = !_obscurePassword;
                              });
                            },
                          ),
                        ),
                        validator: (v) =>
                            v == null || v.length < 6 ? 'Min 6 characters' : null,
                      ),

                      const SizedBox(height: 10),

                      // Apply Referral Code
                      Row(
                        children: [
                          Checkbox(
                            value: _applyReferral,
                            activeColor: AppColors.primaryTeal,
                            onChanged: (val) {
                              setState(() {
                                _applyReferral = val ?? false;
                              });
                            },
                          ),
                          const Text(
                            'Apply Referral Code',
                            style: TextStyle(
                              fontSize: 13,
                              color: AppColors.textPrimary,
                            ),
                          ),
                        ],
                      ),

                      if (_applyReferral) ...[
                        const SizedBox(height: 4),
                        TextFormField(
                          controller: _referralController,
                          decoration: const InputDecoration(
                            labelText: 'Referral Code',
                            prefixIcon: Icon(
                              Icons.card_giftcard,
                              color: AppColors.primaryTeal,
                            ),
                          ),
                        ),
                      ],

                      const SizedBox(height: 16),

                      // Sign up Button
                      SizedBox(
                        width: double.infinity,
                        height: 48,
                        child: ElevatedButton(
                          onPressed: _onSignUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryTeal,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Sign up',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              // Footer Navigation Links
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (ctx) => const SupportCenterScreen(),
                    ),
                  );
                },
                child: const Text(
                  'Support Center',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 10),

              GestureDetector(
                onTap: _openLanguageSettings,
                child: Text(
                  'Choose Preferred Language -$currentLanguage',
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.primaryTeal,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
