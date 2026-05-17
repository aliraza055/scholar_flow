import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:scholar_flow/screens/attendance_sheet.dart';
import 'package:scholar_flow/screens/dashboard_screen.dart';
import 'package:scholar_flow/screens/performance_analysis.dart';

class DashboardBottomNav extends StatefulWidget {
  const DashboardBottomNav({super.key});

  @override
  State<DashboardBottomNav> createState() => _DashboardBottomNavState();
}

class _DashboardBottomNavState extends State<DashboardBottomNav> {
  int _selected = 0;

  final List<Widget> _pages = [
    DashboardView(),
    AttendanceScreen(),
    PerformanceAnalyticsPage(),
  ];

  static const _items = [
    _NavItem(
      icon: Icons.dashboard_rounded,
      activeIcon: Icons.dashboard_rounded,
      label: 'Dashboard',
    ),
    _NavItem(
      icon: Icons.fact_check_outlined,
      activeIcon: Icons.fact_check_rounded,
      label: 'Attendance',
    ),
    _NavItem(
      icon: Icons.bar_chart_outlined,
      activeIcon: Icons.bar_chart_rounded,
      label: 'Performance',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // we handle back ourselves
      onPopInvoked: (didPop) {
        if (_selected != 0) {
          // Any tab other than Dashboard → go back to Dashboard
          setState(() => _selected = 0);
        } else {
          // Already on Dashboard → exit app
          SystemNavigator.pop();
        }
      },
      child: Scaffold(
        extendBody: true, // body goes under the floating nav
        body: IndexedStack(index: _selected, children: _pages),
        bottomNavigationBar: _buildBottomNav(),
      ),
    );
  }

  Widget _buildBottomNav() {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0F2041).withOpacity(0.35),
            blurRadius: 24,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: List.generate(_items.length, (index) {
          final item = _items[index];
          final isActive = _selected == index;

          return GestureDetector(
            onTap: () => setState(() => _selected = index),
            behavior: HitTestBehavior.opaque,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: isActive ? Color(0xFF1A3A6E) : Color(0xFF1A3A6E),
                borderRadius: BorderRadius.circular(16),
                border: isActive
                    ? Border.all(color: Colors.white.withOpacity(0.15))
                    : null,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    isActive ? item.activeIcon : item.icon,
                    size: 20,
                    color: isActive
                        ? Colors.white
                        : Colors.white.withOpacity(0.45),
                  ),
                  AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    curve: Curves.easeInOut,
                    child: isActive
                        ? Row(
                            children: [
                              const SizedBox(width: 8),
                              Text(
                                item.label,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: -0.2,
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}

class _NavItem {
  final IconData icon;
  final IconData activeIcon;
  final String label;

  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });
}
