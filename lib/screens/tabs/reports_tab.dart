import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';

class ReportsTab extends StatefulWidget {
  const ReportsTab({super.key});

  @override
  State<ReportsTab> createState() => _ReportsTabState();
}

class _ReportsTabState extends State<ReportsTab>
    with SingleTickerProviderStateMixin {
  late TabController _reportTabController;
  String _selectedPeriod = 'Week';
  bool _isGraphView = true;

  final List<String> _reportCategories = const [
    'Trends',
    'Sales',
    'Payment Insights',
    'Plan Due',
    'Due Trend',
    'PT Plan Due',
  ];

  @override
  void initState() {
    super.initState();
    _reportTabController =
        TabController(length: _reportCategories.length, vsync: this);
  }

  @override
  void dispose() {
    _reportTabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F5F9),
      body: Column(
        children: [
          // Scrollable Sub-tabs Header (Trends, Sales, Payment Insights...)
          Container(
            color: Colors.white,
            child: TabBar(
              controller: _reportTabController,
              isScrollable: true,
              labelColor: AppColors.primaryTeal,
              unselectedLabelColor: AppColors.textSecondary,
              indicatorColor: AppColors.primaryTeal,
              indicatorWeight: 3,
              labelStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              unselectedLabelStyle: const TextStyle(fontSize: 13),
              tabAlignment: TabAlignment.start,
              tabs: _reportCategories.map((c) => Tab(text: c)).toList(),
            ),
          ),

          // Period Filter & Graph/Table Switch
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            color: const Color(0xFFF8FAFC),
            child: Row(
              children: [
                // Period Filters (Week, Quarter, Six month, Yearly)
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.all(3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE2E8F0),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      children: ['Week', 'Quarter', 'Six month', 'Yearly']
                          .map((p) {
                        final isSel = p == _selectedPeriod;
                        return Expanded(
                          child: InkWell(
                            onTap: () => setState(() => _selectedPeriod = p),
                            borderRadius: BorderRadius.circular(6),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 6),
                              decoration: BoxDecoration(
                                color: isSel
                                    ? AppColors.primaryTeal
                                    : Colors.transparent,
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Center(
                                child: Text(
                                  p,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isSel
                                        ? FontWeight.bold
                                        : FontWeight.w500,
                                    color: isSel
                                        ? Colors.white
                                        : AppColors.textSecondary,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

                const SizedBox(width: 8),

                // Graph / Table Toggle Button
                Container(
                  height: 32,
                  decoration: BoxDecoration(
                    color: const Color(0xFF005C5E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () => setState(() => _isGraphView = true),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: _isGraphView
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Graph',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: _isGraphView
                                  ? AppColors.primaryTeal
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () => setState(() => _isGraphView = false),
                        borderRadius: BorderRadius.circular(16),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: !_isGraphView
                                ? Colors.white
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            'Table',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: !_isGraphView
                                  ? AppColors.primaryTeal
                                  : Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Reports Content
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 1. Collected Payment Chart Card
                _buildReportChartCard(
                  title: 'Collected Payment',
                  maxVal: '2010',
                  minVal: '0',
                  highlightBarDay: 'Thu',
                  barColor: const Color(0xFF86EFAC),
                  barHeightFactor: 0.85,
                ),

                const SizedBox(height: 16),

                // 2. New Member Chart Card
                _buildReportChartCard(
                  title: 'New Member',
                  maxVal: '1.1',
                  minVal: '0.0',
                  highlightBarDay: 'Thu',
                  barColor: const Color(0xFF5EEAD4),
                  barHeightFactor: 0.75,
                ),

                const SizedBox(height: 16),

                // 3. Expired Member Chart Card
                _buildReportChartCard(
                  title: 'Expired Member',
                  maxVal: '10.0',
                  minVal: '0.0',
                  highlightBarDay: '',
                  barColor: const Color(0xFFFCA5A5),
                  barHeightFactor: 0.0,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReportChartCard({
    required String title,
    required String maxVal,
    required String minVal,
    required String highlightBarDay,
    required Color barColor,
    required double barHeightFactor,
  }) {
    final days = ['Thu', 'Wed', 'Tue', 'Mon', 'Sun', 'Sat', 'Fri'];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.borderLight),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title with teal vertical bar
          Row(
            children: [
              Container(
                width: 3.5,
                height: 16,
                decoration: BoxDecoration(
                  color: AppColors.primaryTeal,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Chart Display
          SizedBox(
            height: 150,
            child: Row(
              children: [
                // Y-Axis labels
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      maxVal,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                    Text(
                      minVal,
                      style: const TextStyle(fontSize: 11, color: AppColors.textMuted),
                    ),
                  ],
                ),
                const SizedBox(width: 10),

                // Graph area
                Expanded(
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: days.map((d) {
                            final isHighlight = d == highlightBarDay;
                            return Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                if (isHighlight && barHeightFactor > 0)
                                  Container(
                                    width: 18,
                                    height: 110 * barHeightFactor,
                                    decoration: BoxDecoration(
                                      color: barColor,
                                      borderRadius: const BorderRadius.vertical(
                                        top: Radius.circular(4),
                                      ),
                                    ),
                                  )
                                else
                                  const SizedBox(height: 2),
                              ],
                            );
                          }).toList(),
                        ),
                      ),
                      const Divider(height: 1, color: AppColors.borderLight),
                      const SizedBox(height: 6),
                      // Days X-Axis labels
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: days.map((d) {
                          return Text(
                            d,
                            style: const TextStyle(
                              fontSize: 11,
                              color: AppColors.textSecondary,
                            ),
                          );
                        }).toList(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
