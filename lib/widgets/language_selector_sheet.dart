import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../state/app_state.dart';

class LanguageSelectorSheet extends StatefulWidget {
  const LanguageSelectorSheet({super.key});

  static Future<String?> show(BuildContext context) {
    return showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => const LanguageSelectorSheet(),
    );
  }

  @override
  State<LanguageSelectorSheet> createState() => _LanguageSelectorSheetState();
}

class _LanguageSelectorSheetState extends State<LanguageSelectorSheet> {
  final TextEditingController _searchController = TextEditingController();
  late String _selectedLanguage;

  final List<Map<String, String>> _allLanguages = const [
    {'name': 'English', 'native': 'English'},
    {'name': 'Hindi', 'native': 'हिंदी'},
    {'name': 'Hinglish', 'native': 'Hinglish'},
    {'name': 'Marathi', 'native': 'मराठी'},
    {'name': 'Gujarati', 'native': 'ગુજરાતી'},
    {'name': 'Punjabi', 'native': 'ਪੰਜਾਬੀ'},
    {'name': 'Kannada', 'native': 'ಕನ್ನಡ'},
    {'name': 'Telugu', 'native': 'తెలుగు'},
    {'name': 'Tamil', 'native': 'தமிழ்'},
    {'name': 'Bengali', 'native': 'বাংলা'},
  ];

  late List<Map<String, String>> _filteredLanguages;

  @override
  void initState() {
    super.initState();
    _selectedLanguage = AppState.instance.selectedLanguage;
    _filteredLanguages = List.from(_allLanguages);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterLanguages(String query) {
    setState(() {
      if (query.trim().isEmpty) {
        _filteredLanguages = List.from(_allLanguages);
      } else {
        _filteredLanguages = _allLanguages
            .where((item) =>
                item['name']!.toLowerCase().contains(query.toLowerCase()) ||
                item['native']!.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);

    return Container(
      height: mediaQuery.size.height * 0.85,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(height: 12),
          // Handle bar
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          const SizedBox(height: 18),
          // Title
          const Text(
            'Language Settings',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Choose your preferred language for\nTrackMyGym',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
              height: 1.3,
            ),
          ),
          const SizedBox(height: 16),
          // Search Box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: TextField(
              controller: _searchController,
              onChanged: _filterLanguages,
              decoration: InputDecoration(
                hintText: 'Search language',
                prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                fillColor: const Color(0xFFF1F5F9),
                filled: true,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: AppColors.primaryTeal, width: 1.5),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Languages list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              itemCount: _filteredLanguages.length,
              itemBuilder: (context, index) {
                final item = _filteredLanguages[index];
                final isSelected = item['name'] == _selectedLanguage ||
                    item['native'] == _selectedLanguage;

                return Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedLanguage = item['name']!;
                      });
                    },
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: isSelected
                            ? const Color(0xFFF1F5F9)
                            : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: [
                          if (isSelected)
                            const Icon(
                              Icons.check,
                              color: AppColors.primaryTeal,
                              size: 20,
                            )
                          else
                            const Icon(
                              Icons.translate,
                              color: AppColors.textSecondary,
                              size: 20,
                            ),
                          const SizedBox(width: 14),
                          Text(
                            item['native']!,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w400,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          if (item['name'] != item['native']) ...[
                            const SizedBox(width: 8),
                            Text(
                              '(${item['name']})',
                              style: const TextStyle(
                                fontSize: 13,
                                color: AppColors.textMuted,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Bottom button
          Padding(
            padding: const EdgeInsets.all(20),
            child: ElevatedButton(
              onPressed: () {
                AppState.instance.setLanguage(_selectedLanguage);
                Navigator.of(context).pop(_selectedLanguage);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryTeal,
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              child: const Text(
                'Next',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
