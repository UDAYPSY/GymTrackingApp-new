import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import '../../state/app_state.dart';
import '../../models/member_model.dart';
import '../add_member_screen.dart';

class MembersTab extends StatefulWidget {
  const MembersTab({super.key});

  @override
  State<MembersTab> createState() => _MembersTabState();
}

class _MembersTabState extends State<MembersTab> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _filterScrollController = ScrollController();

  bool _searchByMid = false;
  String _selectedStatusFilter = 'All';
  String _selectedSorting = 'Needs Attention First';
  String _selectedPlanFilter = 'All Plans';
  String _selectedBatchFilter = 'Select Batch';
  String _selectedGenderFilter = 'Select Gender';

  @override
  void dispose() {
    _searchController.dispose();
    _filterScrollController.dispose();
    super.dispose();
  }

  List<MemberModel> _getFilteredMembers(List<MemberModel> allMembers) {
    var list = List<MemberModel>.from(allMembers);

    // Search query filter
    final query = _searchController.text.trim().toLowerCase();
    if (query.isNotEmpty) {
      if (_searchByMid) {
        list = list
            .where((m) => m.membershipId.toLowerCase().contains(query))
            .toList();
      } else {
        list = list.where((m) {
          final nameMatch = m.name?.toLowerCase().contains(query) ?? false;
          final phoneMatch = m.phone?.toLowerCase().contains(query) ?? false;
          return nameMatch || phoneMatch;
        }).toList();
      }
    }

    // Status filter
    if (_selectedStatusFilter == 'Active') {
      list = list.where((m) => m.status == 'Active').toList();
    } else if (_selectedStatusFilter == 'Due') {
      list = list.where((m) => m.dueAmount > 0).toList();
    } else if (_selectedStatusFilter == 'Expired') {
      list = list.where((m) => m.status == 'Expired').toList();
    }

    // Plan filter
    if (_selectedPlanFilter != 'All Plans') {
      list = list.where((m) => m.plan.name == _selectedPlanFilter).toList();
    }

    // Batch filter
    if (_selectedBatchFilter != 'Select Batch') {
      list = list.where((m) => m.batch.contains(_selectedBatchFilter)).toList();
    }

    // Sorting
    if (_selectedSorting == 'Needs Attention First') {
      list.sort((a, b) => b.dueAmount.compareTo(a.dueAmount));
    } else if (_selectedSorting == 'Recently Added') {
      list.sort((a, b) => b.joiningDate.compareTo(a.joiningDate));
    }

    return list;
  }

  void _showCurrencyPicker() {
    final currencies = [
      '₹ (INR) - Indian Rupee',
      '$ (USD) - US Dollar',
      '€ (EUR) - Euro',
      '£ (GBP) - British Pound',
      'AED - UAE Dirham',
      'CAD - Canadian Dollar',
      'AUD - Australian Dollar',
    ];

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                'Select Gym Currency',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 12),
              ...currencies.map((curr) {
                return ListTile(
                  leading: const Icon(Icons.monetization_on_outlined,
                      color: AppColors.primaryTeal),
                  title: Text(curr, style: const TextStyle(fontSize: 14)),
                  trailing: AppState.instance.selectedCurrency == curr
                      ? const Icon(Icons.check, color: AppColors.primaryTeal)
                      : null,
                  onTap: () {
                    AppState.instance.setCurrency(curr.split(' ').first);
                    Navigator.pop(ctx);
                    setState(() {});
                  },
                );
              }).toList(),
              const SizedBox(height: 12),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = AppState.instance;
    final filteredMembers = _getFilteredMembers(state.members);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Stack(
        children: [
          Column(
            children: [
              // Search & M ID Toggle Header (Teal Background Area)
              Container(
                color: AppColors.primaryTeal,
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                child: Row(
                  children: [
                    // Search Bar
                    Expanded(
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: TextField(
                                controller: _searchController,
                                onChanged: (_) => setState(() {}),
                                decoration: InputDecoration(
                                  hintText: _searchByMid
                                      ? 'Search for "M ID"'
                                      : 'Search for "Name" or "Mobile"',
                                  hintStyle: const TextStyle(
                                    fontSize: 13,
                                    color: AppColors.textMuted,
                                  ),
                                  border: InputBorder.none,
                                  enabledBorder: InputBorder.none,
                                  focusedBorder: InputBorder.none,
                                  contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 12,
                                  ),
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => setState(() {}),
                              child: Container(
                                height: 44,
                                width: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF007A7C),
                                  borderRadius: BorderRadius.horizontal(
                                    right: Radius.circular(8),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.search,
                                  color: Colors.white,
                                  size: 22,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // M ID Toggle
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFF004D4F),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          const Text(
                            'M ID',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(width: 4),
                          SizedBox(
                            height: 24,
                            width: 36,
                            child: Switch(
                              value: _searchByMid,
                              activeColor: Colors.white,
                              activeTrackColor: const Color(0xFF10B981),
                              inactiveThumbColor: Colors.grey.shade400,
                              inactiveTrackColor: Colors.white24,
                              onChanged: (val) {
                                setState(() {
                                  _searchByMid = val;
                                  _searchController.clear();
                                });
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Smooth Horizontal Filter Chips Row (Touch + Mouse Drag enabled)
              ScrollConfiguration(
                behavior: const MaterialScrollBehavior().copyWith(
                  dragDevices: {
                    PointerDeviceKind.touch,
                    PointerDeviceKind.mouse,
                    PointerDeviceKind.trackpad,
                  },
                ),
                child: SizedBox(
                  height: 48,
                  child: ListView(
                    controller: _filterScrollController,
                    scrollDirection: Axis.horizontal,
                    physics: const BouncingScrollPhysics(
                      parent: AlwaysScrollableScrollPhysics(),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    children: [
                      // Filter 1: Status
                      _buildInteractiveChip(
                        label: _selectedStatusFilter,
                        items: ['All', 'Active', 'Due', 'Expired'],
                        onSelected: (v) =>
                            setState(() => _selectedStatusFilter = v),
                      ),
                      const SizedBox(width: 8),

                      // Filter 2: Sorting
                      _buildInteractiveChip(
                        label: _selectedSorting,
                        items: [
                          'Needs Attention First',
                          'Recently Added',
                        ],
                        onSelected: (v) => setState(() => _selectedSorting = v),
                      ),
                      const SizedBox(width: 8),

                      // Filter 3: Plans
                      _buildInteractiveChip(
                        label: _selectedPlanFilter,
                        items: [
                          'All Plans',
                          ...state.plans.map((p) => p.name)
                        ],
                        onSelected: (v) =>
                            setState(() => _selectedPlanFilter = v),
                      ),
                      const SizedBox(width: 8),

                      // Filter 4: Batch
                      _buildInteractiveChip(
                        label: _selectedBatchFilter,
                        items: [
                          'Select Batch',
                          'Morning',
                          'Evening',
                          'General',
                        ],
                        onSelected: (v) =>
                            setState(() => _selectedBatchFilter = v),
                      ),
                      const SizedBox(width: 8),

                      // Filter 5: Gender
                      _buildInteractiveChip(
                        label: _selectedGenderFilter,
                        items: [
                          'Select Gender',
                          'Male',
                          'Female',
                        ],
                        onSelected: (v) =>
                            setState(() => _selectedGenderFilter = v),
                      ),
                      const SizedBox(width: 20),
                    ],
                  ),
                ),
              ),

              // Member List or Empty State
              Expanded(
                child: filteredMembers.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Text(
                              'No Members Found',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            const Text(
                              'You can add a new member by clicking\nthe button below',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 14),
                            const Text(
                              'OR',
                              style: TextStyle(
                                fontSize: 12,
                                color: AppColors.textMuted,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ElevatedButton(
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (ctx) => const AddMemberScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primaryTeal,
                                minimumSize: const Size(160, 42),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                              child: const Text(
                                'Add Member',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(16, 8, 16, 90),
                        physics: const AlwaysScrollableScrollPhysics(),
                        itemCount: filteredMembers.length,
                        itemBuilder: (ctx, i) {
                          final m = filteredMembers[i];
                          return Container(
                            margin: const EdgeInsets.only(bottom: 12),
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
                                Row(
                                  children: [
                                    CircleAvatar(
                                      radius: 24,
                                      backgroundColor:
                                          const Color(0xFFE2E8F0),
                                      child: Text(
                                        '#${m.membershipId}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.primaryTeal,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            m.name?.isNotEmpty == true
                                                ? m.name!
                                                : 'Member #${m.membershipId}',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 15,
                                              color: AppColors.textPrimary,
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            '${m.plan.name} • ${m.phone?.isNotEmpty == true ? m.phone : "No Phone"}',
                                            style: const TextStyle(
                                              fontSize: 12,
                                              color: AppColors.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        Text(
                                          '₹${m.planAmount.toStringAsFixed(0)}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                          ),
                                        ),
                                        const SizedBox(height: 2),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 2),
                                          decoration: BoxDecoration(
                                            color: m.isPaidFull
                                                ? Colors.green.shade50
                                                : Colors.orange.shade50,
                                            borderRadius:
                                                BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            m.isPaidFull
                                                ? 'PAID'
                                                : 'Due: ₹${m.dueAmount.toStringAsFixed(0)}',
                                            style: TextStyle(
                                              fontSize: 10,
                                              fontWeight: FontWeight.bold,
                                              color: m.isPaidFull
                                                  ? AppColors.successGreen
                                                  : AppColors.warningOrange,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                const Divider(height: 18),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'Batch: ${m.batch}',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        color: AppColors.textMuted,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        InkWell(
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Calling ${m.name}...'),
                                                backgroundColor:
                                                    AppColors.primaryTeal,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFF1F5F9),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.phone,
                                              size: 16,
                                              color: AppColors.primaryTeal,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        InkWell(
                                          onTap: () {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Messaging ${m.name} on WhatsApp...'),
                                                backgroundColor:
                                                    AppColors.whatsappGreen,
                                              ),
                                            );
                                          },
                                          child: Container(
                                            padding: const EdgeInsets.all(6),
                                            decoration: BoxDecoration(
                                              color: const Color(0xFFDCFCE7),
                                              borderRadius:
                                                  BorderRadius.circular(6),
                                            ),
                                            child: const Icon(
                                              Icons.chat,
                                              size: 16,
                                              color: AppColors.whatsappGreen,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
              ),

              // Currency Alert Strip at Bottom (Clickable!)
              InkWell(
                onTap: _showCurrencyPicker,
                child: Container(
                  width: double.infinity,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  color: const Color(0xFFFEF3C7),
                  child: Row(
                    children: [
                      const Text('💰 ', style: TextStyle(fontSize: 14)),
                      Expanded(
                        child: Text(
                          "Currency: ${state.selectedCurrency} (Tap to change)",
                          style: const TextStyle(
                            fontSize: 12,
                            color: Color(0xFF92400E),
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      const Text(
                        'Change',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.primaryTeal,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          // Floating Action Button
          Positioned(
            right: 16,
            bottom: 54,
            child: ElevatedButton.icon(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (ctx) => const AddMemberScreen(),
                  ),
                );
              },
              icon: const Icon(Icons.person_add, color: Colors.white, size: 18),
              label: const Text(
                'Add Member',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                elevation: 4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveChip({
    required String label,
    required List<String> items,
    required ValueChanged<String> onSelected,
  }) {
    return PopupMenuButton<String>(
      onSelected: onSelected,
      color: Colors.white,
      itemBuilder: (context) {
        return items.map((item) {
          return PopupMenuItem<String>(
            value: item,
            child: Text(item, style: const TextStyle(fontSize: 13)),
          );
        }).toList();
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.borderLight),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: AppColors.textPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: 4),
            const Icon(Icons.arrow_drop_down,
                size: 16, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}
