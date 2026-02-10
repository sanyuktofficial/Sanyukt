import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

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

  Future<void> _handleBack() async {
    if (_currentIndex != 0) {
      setState(() => _currentIndex = 0);
    } else {
      final exit = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (ctx) {
          final scheme = Theme.of(ctx).colorScheme;
          final primary = scheme.primary;
          return Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            elevation: 0,
            child: Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: scheme.surfaceContainerHighest,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.15),
                    blurRadius: 24,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.exit_to_app_rounded, size: 40, color: primary),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Exit Sanyukt?',
                    style: Theme.of(ctx).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w600,
                          color: scheme.onSurface,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Are you sure you want to leave? You can come back anytime.',
                    textAlign: TextAlign.center,
                    style: Theme.of(ctx).textTheme.bodyMedium?.copyWith(
                          color: scheme.onSurfaceVariant,
                        ),
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(ctx).pop(false),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Stay'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => Navigator.of(ctx).pop(true),
                          style: FilledButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: scheme.onPrimary,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Exit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      );
      if (exit == true && mounted) {
        SystemNavigator.pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final navBg = isDark ? bottomNavBarBackgroundDark : bottomNavBarBackground;
    final navSelected = isDark ? bottomNavSelectedColorDark : bottomNavSelectedColor;
    final navUnselected = isDark ? bottomNavUnselectedColorDark : bottomNavUnselectedColor;
    final navIconActive = isDark ? Colors.white : appBarBackground;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (didPop) return;
        _handleBack();
      },
      child: Scaffold(
        body: IndexedStack(
          index: _currentIndex,
          children: _screens,
        ),
        bottomNavigationBar: CurvedNavigationBar(
          index: _currentIndex,
          onTap: (index) => setState(() => _currentIndex = index),
          backgroundColor: Theme.of(context).colorScheme.surface,
          color: navBg,
          buttonBackgroundColor: navSelected,
          height: 58,
          animationDuration: const Duration(milliseconds: 320),
          animationCurve: Curves.easeOutCubic,
          items: [
            Icon(
              Icons.dashboard_rounded,
              size: 28,
              color: _currentIndex == 0 ? navIconActive : navUnselected,
            ),
            Icon(
              Icons.home_rounded,
              size: 28,
              color: _currentIndex == 1 ? navIconActive : navUnselected,
            ),
            Icon(
              Icons.person_rounded,
              size: 28,
              color: _currentIndex == 2 ? navIconActive : navUnselected,
            ),
          ],
        ),
      ),
    );
  }
}
