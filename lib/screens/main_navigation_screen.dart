// screens/main_navigation_screen.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import '../theme/lavender_theme.dart';
import 'wishes_screen.dart';
import 'calendar_screen.dart';
import 'character_collection_screen.dart';
import 'settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const WishesScreen(),
    const CalendarScreen(),
    const CharacterCollectionScreen(),
    const SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F3FF), // 아주 연한 라벤더
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: GlassmorphicContainer(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.symmetric(vertical: 8),
        borderRadius: BorderRadius.circular(25),
        blur: 15,
        opacity: 0.15,
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: const Color(0xFF7C3AED),
          unselectedItemColor: const Color(0xFF9CA3AF),
          selectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          unselectedLabelStyle: const TextStyle(
            fontWeight: FontWeight.normal,
            fontSize: 12,
          ),
          items: [
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/wish.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/wish.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color: const Color(0xFF7C3AED),
              ),
              label: l10n.navWishes,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/calendar.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/calendar.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color: const Color(0xFF7C3AED),
              ),
              label: l10n.navCalendar,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/collection.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/collection.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color: const Color(0xFF7C3AED),
              ),
              label: l10n.navCollection,
            ),
            BottomNavigationBarItem(
              icon: Image.asset(
                'assets/setting.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
              ),
              activeIcon: Image.asset(
                'assets/setting.png',
                width: 24,
                height: 24,
                fit: BoxFit.contain,
                color: const Color(0xFF7C3AED),
              ),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }
}
