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
  int _selected = 0;

  final List<Widget> _pages = [
    DashboardView(),
    AttendanceScreen(),
    PerformanceAnalyticsPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: _pages[_selected],

      bottomNavigationBar: Container(
        margin: const EdgeInsets.all(12),
        padding: const EdgeInsets.symmetric(vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(color: Colors.black12, blurRadius: 10, spreadRadius: 2),
          ],
        ),

        child: BottomNavigationBar(
          currentIndex: _selected,
          onTap: (index) {
            setState(() {
              _selected = index;
            });
          },

          type: BottomNavigationBarType.fixed,

          backgroundColor: Colors.transparent,
          elevation: 0,

          selectedItemColor: Color(0xFF006692), // 🔵 BLUE ACTIVE
          unselectedItemColor: Colors.grey,

          showUnselectedLabels: true,

          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.dashboard),
              label: 'Dashboard',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.check_circle),
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
