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
          selectedItemColor: const Color(0xFFB4A7FF), // 라벤더
          unselectedItemColor: const Color(0xFFB4A7FF), // 라벤더

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
              icon: _buildNavIcon('assets/wish.png', 0),
              activeIcon: _buildActiveNavIcon('assets/wish.png', 0),
              label: l10n.navWishes,
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/calendar.png', 1),
              activeIcon: _buildActiveNavIcon('assets/calendar.png', 1),
              label: l10n.navCalendar,
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/collection.png', 2),
              activeIcon: _buildActiveNavIcon('assets/collection.png', 2),
              label: l10n.navCollection,
            ),
            BottomNavigationBarItem(
              icon: _buildNavIcon('assets/setting.png', 3),
              activeIcon: _buildActiveNavIcon('assets/setting.png', 3),
              label: l10n.navSettings,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildNavIcon(String assetPath, int index) {
    return Image.asset(
      assetPath,
      width: 24,
      height: 24,
      fit: BoxFit.contain,
      color: const Color(0xFFB4A7FF),
    );
  }

  Widget _buildActiveNavIcon(String assetPath, int index) {
    return TweenAnimationBuilder<double>(
      tween: Tween(begin: 1.0, end: 1.2),
      duration: const Duration(milliseconds: 300),
      builder: (context, scale, child) {
        return Transform.scale(
          scale: scale,
          child: Image.asset(
            assetPath,
            width: 24,
            height: 24,
            fit: BoxFit.contain,
          ),
        );
      },
    );
  }
}
