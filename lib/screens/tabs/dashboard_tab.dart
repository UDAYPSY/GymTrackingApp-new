import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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

  // Calendar State
  DateTime _currentMonth = DateTime(2026, 11, 1);
  late DateTime _selectedDate;

  // Payments Filter State
  String _monthFilter = 'This Month';
  String _yearFilter = 'This Year';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedDate = DateTime(2026, 11, 19);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _changeMonth(int offset) {
    setState(() {
      _currentMonth = DateTime(
        _currentMonth.year,
        _currentMonth.month + offset,
        1,
      );
      _selectedDate = DateTime(
        _currentMonth.year,
        _currentMonth.month,
        1,
      );
    });
  }

  void _openRecordAttendanceDialog([DateTime? targetDate]) {
    final state = AppState.instance;
    final date = targetDate ?? _selectedDate;
    final messenger = ScaffoldMessenger.of(context);

    if (state.members.isEmpty) {
      messenger.showSnackBar(
        const SnackBar(
          content: Text('Please add a member before recording attendance.'),
          backgroundColor: AppColors.primaryTeal,
        ),
      );
      return;
    }

    String selectedMemberId = state.members.first.membershipId;
    String time = DateFormat('hh:mm a').format(DateTime.now());

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (dialogCtx, setDialogState) {
            return AlertDialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              title: Row(
                children: const [
                  Icon(Icons.assignment_turned_in,
                      color: AppColors.primaryTeal),
                  SizedBox(width: 8),
                  Text('Record Attendance', style: TextStyle(fontSize: 18)),
                ],
              ),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Date: ${DateFormat('dd MMMM yyyy').format(date)}',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 14),
                  const Text('Select Member:',
                      style: TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                  const SizedBox(height: 6),
                  DropdownButtonFormField<String>(
                    value: selectedMemberId,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    items: state.members.map((m) {
                      return DropdownMenuItem(
                        value: m.membershipId,
                        child: Text('${m.name} (#${m.membershipId})'),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setDialogState(() => selectedMemberId = val);
                      }
                    },
                  ),
                  const SizedBox(height: 14),
                  Text('Check-in Time: $time',
                      style: const TextStyle(
                          fontSize: 13, color: AppColors.textSecondary)),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    final member = state.members.firstWhere(
                      (m) => m.membershipId == selectedMemberId,
                    );
                    state.recordAttendance(
                      memberId: member.membershipId,
                      memberName: member.name ?? 'Member',
                      date: date,
                      time: time,
                    );
                    Navigator.pop(ctx);
                    setState(() {});
                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                            'Attendance recorded for ${member.name}!'),
                        backgroundColor: AppColors.successGreen,
                      ),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryTeal,
                  ),
                  child: const Text('Save Entry'),
                ),
              ],
            );
          },
        );
      },
    );
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
              labelStyle:
                  const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              tabs: const [
                Tab(text: 'Membership'),
                Tab(text: 'Payments'),
                Tab(text: 'Attendance'),
              ],
            ),
          ),

          // Scrollable Tab Views
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
    final todayAttendanceCount =
        state.getAttendanceForDate(DateTime(2026, 11, 19)).length;

    return Stack(
      children: [
        ListView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
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
                    '$todayAttendanceCount',
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
                    '${state.attendanceRecords.length}',
                    'Monthly Check-ins',
                    Icons.calendar_month_outlined,
                    AppColors.primaryTeal,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _buildMetricCard(
                    '${state.attendanceRecords.isNotEmpty ? 1 : 0}',
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

        // Record Attendance Floating Button
        Positioned(
          right: 16,
          bottom: 20,
          child: ElevatedButton.icon(
            onPressed: () => _openRecordAttendanceDialog(DateTime(2026, 11, 19)),
            icon: const Icon(Icons.assignment_turned_in,
                color: Colors.white, size: 18),
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
    final state = AppState.instance;

    final totalCollected = state.members.fold<double>(
      0.0,
      (sum, m) => sum + m.paidAmount,
    );
    final totalDue = state.members.fold<double>(
      0.0,
      (sum, m) => sum + m.dueAmount,
    );
    final totalAdmission = state.members.fold<double>(
      0.0,
      (sum, m) => sum + m.admissionFees,
    );

    final currency = NumberFormat('#,##,###');

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
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
                children: [
                  Text(
                    '₹${currency.format(totalCollected)}',
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: AppColors.successGreen,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
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
          options: const ['This Month', 'Last Month', 'Last 3 Months', 'Custom'],
          onSelected: (v) => setState(() => _monthFilter = v),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalAdmission)}',
                'Admission Fees',
                AppColors.successGreen,
                Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalCollected)}',
                'Membership Collected',
                AppColors.successGreen,
                Icons.payments_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalDue)}',
                'Membership Due',
                AppColors.errorRed,
                Icons.account_balance_wallet_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCurrencyCard(
                '₹0',
                'PT Due',
                AppColors.errorRed,
                Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalCollected)}',
                'Service Paid',
                AppColors.successGreen,
                Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCurrencyCard(
                '₹0',
                'Service Due',
                AppColors.errorRed,
                Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildCurrencyCard(
          '₹0',
          'Expense',
          AppColors.errorRed,
          Icons.payments_outlined,
        ),

        const SizedBox(height: 20),

        // Section: Financial Summary
        _buildSectionHeader('Financial Summary – 2026-01 to 2026-11'),
        _buildPillFilters(
          selected: _yearFilter,
          options: const ['This Year', 'Last Year', 'Lifetime', 'Custom'],
          onSelected: (v) => setState(() => _yearFilter = v),
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalAdmission)}',
                'Admission Fees',
                AppColors.successGreen,
                Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalCollected)}',
                'Membership Collected',
                AppColors.successGreen,
                Icons.payments_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalDue)}',
                'Membership Due',
                AppColors.errorRed,
                Icons.info_outline,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCurrencyCard(
                '₹0',
                'PT Due',
                AppColors.errorRed,
                Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Expanded(
              child: _buildCurrencyCard(
                '₹${currency.format(totalCollected)}',
                'Service Paid',
                AppColors.successGreen,
                Icons.payments_outlined,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: _buildCurrencyCard(
                '₹0',
                'Service Due',
                AppColors.errorRed,
                Icons.account_balance_wallet_outlined,
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _buildCurrencyCard(
          '₹0',
          'Expense',
          AppColors.errorRed,
          Icons.payments_outlined,
        ),
      ],
    );
  }

  // 3. Attendance Sub-Tab
  Widget _buildAttendanceSubTab() {
    final state = AppState.instance;
    final selectedRecords = state.getAttendanceForDate(_selectedDate);
    final monthFormat = DateFormat('MMMM yyyy');

    return ListView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 100),
      children: [
        // Interactive Calendar Card
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.borderLight),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              // Month Header with Prev/Next Navigation
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_left,
                        size: 28, color: AppColors.primaryTeal),
                    onPressed: () => _changeMonth(-1),
                  ),
                  Text(
                    monthFormat.format(_currentMonth),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppColors.primaryTeal,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.arrow_right,
                        size: 28, color: AppColors.primaryTeal),
                    onPressed: () => _changeMonth(1),
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

              // Dynamic Days Grid
              _buildDynamicMonthGrid(),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Date Entry Details Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              DateFormat('dd MMM yyyy').format(_selectedDate),
              style: const TextStyle(
                fontSize: 16,
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
              child: Text(
                'Total: ${selectedRecords.length}',
                style: const TextStyle(
                  fontSize: 12,
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
            onPressed: () => _openRecordAttendanceDialog(_selectedDate),
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

        // Records List or Empty State
        if (selectedRecords.isEmpty)
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
                Icon(Icons.calendar_today_outlined,
                    size: 44, color: AppColors.textMuted),
                SizedBox(height: 10),
                Text(
                  'No attendance records for this date',
                  style:
                      TextStyle(color: AppColors.textSecondary, fontSize: 13),
                ),
              ],
            ),
          )
        else
          ...selectedRecords.map((r) {
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.borderLight),
              ),
              child: Row(
                children: [
                  const CircleAvatar(
                    backgroundColor: Color(0xFFCCFBF1),
                    radius: 18,
                    child: Icon(Icons.check,
                        color: AppColors.primaryTeal, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          r.memberName,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        Text(
                          'Membership #${r.memberId}',
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      r.time,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primaryTeal,
                      ),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
      ],
    );
  }

  Widget _buildDynamicMonthGrid() {
    final state = AppState.instance;

    final firstDayOfMonth =
        DateTime(_currentMonth.year, _currentMonth.month, 1);
    final daysInMonth =
        DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final startWeekday = firstDayOfMonth.weekday % 7; // Sunday = 0

    final totalSlots = ((startWeekday + daysInMonth + 6) ~/ 7) * 7;

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: totalSlots,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 7,
        mainAxisSpacing: 6,
        crossAxisSpacing: 6,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final dayNum = index - startWeekday + 1;
        if (dayNum < 1 || dayNum > daysInMonth) {
          return const SizedBox.shrink();
        }

        final cellDate =
            DateTime(_currentMonth.year, _currentMonth.month, dayNum);
        final isSelected = cellDate.year == _selectedDate.year &&
            cellDate.month == _selectedDate.month &&
            cellDate.day == _selectedDate.day;
        final hasAttendance = state.hasAttendanceOnDate(cellDate);

        return InkWell(
          onTap: () {
            setState(() => _selectedDate = cellDate);
          },
          borderRadius: BorderRadius.circular(8),
          child: Container(
            decoration: BoxDecoration(
              color: isSelected ? AppColors.primaryTeal : Colors.transparent,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '$dayNum',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight:
                        isSelected ? FontWeight.bold : FontWeight.normal,
                    color: isSelected
                        ? Colors.white
                        : AppColors.textPrimary,
                  ),
                ),
                if (hasAttendance)
                  Positioned(
                    bottom: 3,
                    child: Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.successGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
              const Icon(Icons.chevron_right,
                  size: 14, color: AppColors.textMuted),
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
              const Icon(Icons.chevron_right,
                  size: 14, color: AppColors.textMuted),
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
