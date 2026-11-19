import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';
import 'tabs/members_tab.dart';
import 'tabs/dashboard_tab.dart';
import 'tabs/reports_tab.dart';
import 'tabs/gym_tab.dart';
import 'support_center_screen.dart';
import '../widgets/language_selector_sheet.dart';

class DashboardScreen extends StatefulWidget {
  final int initialTabIndex;

  const DashboardScreen({
    super.key,
    this.initialTabIndex = 0,
  });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  late int _currentTabIndex;

  final List<String> _tabTitles = const [
    'Members',
    'Dashboard',
    'Reports',
    'Gym',
  ];

  @override
  void initState() {
    super.initState();
    _currentTabIndex = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppState.instance,
      builder: (context, _) {
        return Scaffold(
          appBar: _buildAppBar(),
          drawer: _buildDrawer(),
          body: IndexedStack(
            index: _currentTabIndex,
            children: const [
              MembersTab(),
              DashboardTab(),
              ReportsTab(),
              GymTab(),
            ],
          ),
          bottomNavigationBar: _buildBottomNav(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primaryTeal,
      elevation: 0,
      leading: Builder(
        builder: (ctx) => IconButton(
          icon: const Icon(Icons.menu, color: Colors.white),
          onPressed: () => Scaffold.of(ctx).openDrawer(),
        ),
      ),
      title: Text(
        _tabTitles[_currentTabIndex],
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      actions: _buildAppBarActions(),
    );
  }

  List<Widget> _buildAppBarActions() {
    if (_currentTabIndex == 0) {
      // Members Tab Actions: Chat bubble with green badge '3', Delete icon, Question icon
      return [
        Stack(
          alignment: Alignment.topRight,
          children: [
            IconButton(
              icon: const Icon(Icons.chat_bubble_outline, color: Colors.white, size: 22),
              onPressed: () {},
            ),
            Positioned(
              right: 6,
              top: 6,
              child: Container(
                padding: const EdgeInsets.all(3),
                decoration: const BoxDecoration(
                  color: Color(0xFF10B981),
                  shape: BoxShape.circle,
                ),
                child: const Text(
                  '3',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
        IconButton(
          icon: const Icon(Icons.delete_outline, color: Colors.white, size: 22),
          onPressed: () {},
        ),
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const SupportCenterScreen()),
            );
          },
        ),
      ];
    } else {
      return [
        IconButton(
          icon: const Icon(Icons.help_outline, color: Colors.white, size: 22),
          onPressed: () {
            Navigator.of(context).push(
              MaterialPageRoute(builder: (ctx) => const SupportCenterScreen()),
            );
          },
        ),
      ];
    }
  }

  Widget _buildDrawer() {
    final state = AppState.instance;

    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(
              color: AppColors.primaryTeal,
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Colors.white,
              child: Text(
                state.gymName.isNotEmpty
                    ? state.gymName[0].toUpperCase()
                    : 'T',
                style: const TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryTeal,
                ),
              ),
            ),
            accountName: Text(
              state.gymName.isNotEmpty
                  ? 'TrackMyGym - ${state.gymName}'
                  : 'TrackMyGym',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            accountEmail: Text(
              state.ownerEmail.isNotEmpty
                  ? state.ownerEmail
                  : 'Owner: ${state.ownerName}',
            ),
          ),
          ListTile(
            leading: const Icon(Icons.people_outline, color: AppColors.primaryTeal),
            title: const Text('Members'),
            selected: _currentTabIndex == 0,
            onTap: () {
              setState(() => _currentTabIndex = 0);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.pie_chart_outline, color: AppColors.primaryTeal),
            title: const Text('Dashboard'),
            selected: _currentTabIndex == 1,
            onTap: () {
              setState(() => _currentTabIndex = 1);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.description_outlined, color: AppColors.primaryTeal),
            title: const Text('Reports'),
            selected: _currentTabIndex == 2,
            onTap: () {
              setState(() => _currentTabIndex = 2);
              Navigator.pop(context);
            },
          ),
          ListTile(
            leading: const Icon(Icons.apartment, color: AppColors.primaryTeal),
            title: const Text('Gym Settings'),
            selected: _currentTabIndex == 3,
            onTap: () {
              setState(() => _currentTabIndex = 3);
              Navigator.pop(context);
            },
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.headset_mic_outlined, color: AppColors.primaryTeal),
            title: const Text('Support Center'),
            onTap: () {
              Navigator.pop(context);
              Navigator.of(context).push(
                MaterialPageRoute(builder: (ctx) => const SupportCenterScreen()),
              );
            },
          ),
          ListTile(
            leading: const Icon(Icons.language, color: AppColors.primaryTeal),
            title: const Text('Language Settings'),
            subtitle: Text(state.selectedLanguage),
            onTap: () {
              Navigator.pop(context);
              LanguageSelectorSheet.show(context);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2E8F0))),
      ),
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(0, Icons.people, 'Members'),
          _buildNavItem(1, Icons.pie_chart, 'Dashboard'),
          _buildNavItem(2, Icons.description, 'Reports'),
          _buildNavItem(3, Icons.apartment, 'Gym'),
        ],
      ),
    );
  }

  Widget _buildNavItem(int index, IconData icon, String label) {
    final isSelected = _currentTabIndex == index;

    return InkWell(
      onTap: () => setState(() => _currentTabIndex = index),
      borderRadius: BorderRadius.circular(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            decoration: BoxDecoration(
              color: isSelected ? const Color(0xFFE8DEF8) : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(
              icon,
              color: isSelected
                  ? const Color(0xFF1D1B20)
                  : AppColors.textSecondary,
              size: 22,
            ),
          ),
          const SizedBox(height: 3),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected ? AppColors.primaryTeal : AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
