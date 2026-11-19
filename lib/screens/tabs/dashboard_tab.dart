import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/app_state.dart';

class DashboardTab extends StatefulWidget {
  const DashboardTab({super.key});

  @override
  State<DashboardTab> createState() => _DashboardTabState();
}

class _DashboardTabState extends State<DashboardTab>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  int _selectedCalendarDay = 19;
  String _monthFilter = 'This Month';
  String _yearFilter = 'This Year';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Sub-Tab Bar (Membership | Payments | Attendance)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              labelColor: AppColors.primaryTeal,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryTeal,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              tabs: const [
                Tab(text: 'Membership'),
                Tab(text: 'Payments'),
                Tab(text: 'Attendance'),
              ],
            ),
          ),

          // Tab Bar Views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                _buildMembershipSubTab(),
                _buildPaymentsSubTab(),
                _buildAttendanceSubTab(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // 1. Membership Sub-Tab
  Widget _buildMembershipSubTab() {
    final state = AppState.instance;
    final activeCount = state.members.length;

    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: Text(
                  'Tap the card for additional information.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.textMuted,
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Section: Today - 19 Nov 2026
              _buildSectionHeader('Today – 19 Nov 2026'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Attendance',
                      Icons.calendar_today_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Birthdays',
                      Icons.cake_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expires Today',
                      Icons.calendar_today_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'PT Plan Expiring Today',
                      Icons.calendar_today_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section: Attendance - November 2026
              _buildSectionHeader('Attendance – November 2026'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Monthly Check-ins',
                      Icons.calendar_month_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Unique Members Attended',
                      Icons.groups_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section: Membership Expiry
              _buildSectionHeader('Membership Expiry'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expiring (1–3d)',
                      Icons.person_search_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expiring (4–7d)',
                      Icons.person_search_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildMetricCard(
                '0',
                'Expiring (8–15d)',
                Icons.person_search_outlined,
                AppColors.primaryTeal,
              ),

              const SizedBox(height: 16),

              // Section: Membership Expired Recently
              _buildSectionHeader('Membership Expired Recently'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expired (1–3d ago)',
                      Icons.person_remove_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expired (4–7d ago)',
                      Icons.person_remove_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section: PT Plan Expiry
              _buildSectionHeader('PT Plan Expiry'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expiring (1–3d)',
                      Icons.person_search_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expiring (4–7d)',
                      Icons.person_search_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildMetricCard(
                '0',
                'Expiring (8–15d)',
                Icons.person_search_outlined,
                AppColors.primaryTeal,
              ),

              const SizedBox(height: 16),

              // Section: Membership Overview
              _buildSectionHeader('Membership Overview'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '$activeCount',
                      'Active Members',
                      Icons.how_to_reg_outlined,
                      AppColors.successGreen,
                      numberColor: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expired Members',
                      Icons.person_off_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '$activeCount',
                      'Total Members',
                      Icons.groups_outlined,
                      AppColors.primaryTeal,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Block Members',
                      Icons.lock_person_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Section: PT Plan Overview
              _buildSectionHeader('PT Plan Overview'),
              Row(
                children: [
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Active PT Plans',
                      Icons.how_to_reg_outlined,
                      AppColors.successGreen,
                      numberColor: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildMetricCard(
                      '0',
                      'Expired PT Plans',
                      Icons.person_off_outlined,
                      AppColors.errorRed,
                      numberColor: AppColors.errorRed,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              _buildMetricCard(
                '0',
                'Total PT Plans',
                Icons.groups_outlined,
                AppColors.primaryTeal,
              ),
            ],
          ),
        ),

        // Record Attendance Floating Button
        Positioned(
          right: 16,
          bottom: 16,
          child: ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Opening Attendance Entry...'),
                  backgroundColor: AppColors.primaryTeal,
                ),
              );
            },
            icon: const Icon(Icons.assignment_turned_in, color: Colors.white, size: 18),
            label: const Text(
              'Record Attendance',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 13,
              ),
            ),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryTeal,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 4,
            ),
          ),
        ),
      ],
    );
  }

  // 2. Payments Sub-Tab
  Widget _buildPaymentsSubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Tap the card for additional information.',
              style: TextStyle(
                fontSize: 12,
                color: AppColors.textMuted,
              ),
            ),
          ),
          const SizedBox(height: 14),

          // Section: Today's Collection
          _buildSectionHeader("Today's Collection – 19 Nov 2026"),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFBBF7D0)),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      '₹0',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: AppColors.successGreen,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Membership Collected Today',
                      style: TextStyle(
                        fontSize: 13,
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const Icon(
                  Icons.payments_outlined,
                  color: AppColors.successGreen,
                  size: 26,
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Section: Nov 2026
          _buildSectionHeader('Nov 2026'),
          _buildPillFilters(
            selected: _monthFilter,
            options: ['This Month', 'Last Month', 'Last 3 Months', 'Custom'],
            onSelected: (v) => setState(() => _monthFilter = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCurrencyCard('₹0', 'Admission Fees', AppColors.successGreen, Icons.payments_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencyCard('₹0', 'Membership Collected', AppColors.successGreen, Icons.payments_outlined)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildCurrencyCard('₹0', 'Membership Due', AppColors.errorRed, Icons.account_balance_wallet_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencyCard('₹0', 'PT Due', AppColors.errorRed, Icons.account_balance_wallet_outlined)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildCurrencyCard('₹0', 'Service Paid', AppColors.successGreen, Icons.payments_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencyCard('₹0', 'Service Due', AppColors.errorRed, Icons.account_balance_wallet_outlined)),
            ],
          ),
          const SizedBox(height: 10),
          _buildCurrencyCard('₹0', 'Expense', AppColors.errorRed, Icons.payments_outlined),

          const SizedBox(height: 20),

          // Section: Financial Summary
          _buildSectionHeader('Financial Summary – 2026-01 to 2026-11'),
          _buildPillFilters(
            selected: _yearFilter,
            options: ['This Year', 'Last Year', 'Lifetime', 'Custom'],
            onSelected: (v) => setState(() => _yearFilter = v),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildCurrencyCard('₹0', 'Admission Fees', AppColors.successGreen, Icons.payments_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencyCard('₹0', 'Membership Collected', AppColors.successGreen, Icons.payments_outlined)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildCurrencyCard('₹0', 'Membership Due', AppColors.errorRed, Icons.info_outline)),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencyCard('₹0', 'PT Due', AppColors.errorRed, Icons.account_balance_wallet_outlined)),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(child: _buildCurrencyCard('₹0', 'Service Paid', AppColors.successGreen, Icons.payments_outlined)),
              const SizedBox(width: 10),
              Expanded(child: _buildCurrencyCard('₹0', 'Service Due', AppColors.errorRed, Icons.account_balance_wallet_outlined)),
            ],
          ),
          const SizedBox(height: 10),
          _buildCurrencyCard('₹0', 'Expense', AppColors.errorRed, Icons.payments_outlined),
        ],
      ),
    );
  }

  // 3. Attendance Sub-Tab
  Widget _buildAttendanceSubTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          // Calendar Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: [
                // Month Header with Prev/Next
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_left, color: AppColors.primaryTeal),
                      onPressed: () {},
                    ),
                    const Text(
                      'November 2026',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.arrow_right, color: AppColors.primaryTeal),
                      onPressed: () {},
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Days of week header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: const [
                    Text('Sun', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text('Mon', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text('Tue', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text('Wed', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text('Thu', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text('Fri', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                    Text('Sat', style: TextStyle(fontSize: 12, color: AppColors.textMuted)),
                  ],
                ),
                const SizedBox(height: 10),

                // 5 Weeks Grid
                _buildCalendarWeek(['1', '2', '3', '4', '5', '6', '7']),
                _buildCalendarWeek(['8', '9', '10', '11', '12', '13', '14']),
                _buildCalendarWeek(['15', '16', '17', '18', '19', '20', '21']),
                _buildCalendarWeek(['22', '23', '24', '25', '26', '27', '28']),
                _buildCalendarWeek(['29', '30', '1', '2', '3', '4', '5'], isFaded: true),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Date Entry Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '$_selectedCalendarDay Nov 2026',
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFCCFBF1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Total: 0',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryTeal,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Add Back-dated Entry Button
          SizedBox(
            width: double.infinity,
            height: 44,
            child: OutlinedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, color: AppColors.primaryTeal, size: 18),
              label: const Text(
                'Add Back-dated Entry',
                style: TextStyle(
                  color: AppColors.primaryTeal,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.primaryTeal, width: 1.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Empty state card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(28),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.borderLight),
            ),
            child: Column(
              children: const [
                Icon(Icons.calendar_today_outlined, size: 44, color: AppColors.textMuted),
                SizedBox(height: 10),
                Text(
                  'No attendance records for this date',
                  style: TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCalendarWeek(List<String> days, {bool isFaded = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: days.map((day) {
          final isSelected = day == '19' && !isFaded;
          return InkWell(
            onTap: () {
              if (int.tryParse(day) != null) {
                setState(() => _selectedCalendarDay = int.parse(day));
              }
            },
            child: Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primaryTeal : Colors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  day,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : (isFaded ? AppColors.textMuted : AppColors.textPrimary),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: AppColors.textPrimary,
        ),
      ),
    );
  }

  Widget _buildMetricCard(
    String count,
    String label,
    IconData icon,
    Color iconColor, {
    Color? numberColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                count,
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: numberColor ?? AppColors.primaryTeal,
                ),
              ),
              Icon(icon, color: iconColor, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCurrencyCard(
    String amount,
    String label,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                amount,
                style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Icon(icon, color: color, size: 18),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.textPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const Icon(Icons.chevron_right, size: 14, color: AppColors.textMuted),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPillFilters({
    required String selected,
    required List<String> options,
    required ValueChanged<String> onSelected,
  }) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: options.map((opt) {
          final isSel = opt == selected;
          return Expanded(
            child: InkWell(
              onTap: () => onSelected(opt),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 8),
                decoration: BoxDecoration(
                  color: isSel ? AppColors.primaryTeal : Colors.transparent,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Center(
                  child: Text(
                    opt,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: isSel ? FontWeight.bold : FontWeight.w500,
                      color: isSel ? Colors.white : AppColors.textSecondary,
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
