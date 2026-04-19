import 'package:flutter/material.dart';
import 'package:scholar_flow/screens/attendance_sheet.dart';
import 'package:scholar_flow/screens/dashboard_screen.dart';
import 'package:scholar_flow/screens/performance_analysis.dart';

class DashboardBottomNav extends StatefulWidget {
  const DashboardBottomNav({super.key});

  @override
  State<DashboardBottomNav> createState() => _DashboardBottomNavState();
}

class _DashboardBottomNavState extends State<DashboardBottomNav> {
  int _seleted = 0;
  final List<Widget> _pages = [
    DashboardView(),
    AttendanceScreen(),
    PerformanceAnalyticsPage(),
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_seleted],
      bottomNavigationBar: Container(
        child: BottomNavigationBar(
          currentIndex: _seleted,
          onTap: (index) {
            setState(() {
              _seleted = index;
            });
          },
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle_outline),
              label: 'Attendance',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.bar_chart),
              label: 'Performance',
            ),
          ],
        ),
      ),
    );
  }
}
