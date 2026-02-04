import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';

import '../../core/app_theme.dart';
import 'home_screen.dart';
import 'home_categories_screen.dart';
import 'profile/profile_screen.dart';

class MainShellScreen extends StatefulWidget {
  const MainShellScreen({super.key});

  static const routePath = '/';
  static const routeName = 'mainShell';

  @override
  State<MainShellScreen> createState() => _MainShellScreenState();
}

class _MainShellScreenState extends State<MainShellScreen> {
  int _currentIndex = 0;

  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();
    _screens = const [
      HomeScreen(),
      HomeCategoriesScreen(),
      ProfileScreen(),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _screens,
      ),
      bottomNavigationBar: CurvedNavigationBar(
        index: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        backgroundColor: Colors.white,
        color: bottomNavBarBackground,
        buttonBackgroundColor: bottomNavSelectedColor,
        height: 58,
        animationDuration: const Duration(milliseconds: 320),
        animationCurve: Curves.easeOutCubic,
        items: [
          Icon(
            Icons.dashboard_rounded,
            size: 28,
            color: _currentIndex == 0 ? appBarBackground : bottomNavUnselectedColor,
          ),
          Icon(
            Icons.home_rounded,
            size: 28,
            color: _currentIndex == 1 ? appBarBackground : bottomNavUnselectedColor,
          ),
          Icon(
            Icons.person_rounded,
            size: 28,
            color: _currentIndex == 2 ? appBarBackground : bottomNavUnselectedColor,
          ),
        ],
      ),
    );
  }
}
