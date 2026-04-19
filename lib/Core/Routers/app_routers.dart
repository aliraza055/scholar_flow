import 'package:flutter/material.dart';
import 'package:scholar_flow/screens/attendance_sheet.dart';
import 'package:scholar_flow/screens/dashboard_screen.dart';
import 'package:scholar_flow/screens/new_entry.dart';
import 'package:scholar_flow/screens/onboard.dart';
import 'package:scholar_flow/screens/record_achivement.dart';

class AppRouters {
  static const appOnboarding = '/';
  static const dashScreen = '/dashboard';
  static const attendanceScreen = '/attendance';
  static const addNew = '/addNew';
  static const record = '/record';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appOnboarding:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(), // check name exists
        );

      case dashScreen:
        return MaterialPageRoute(builder: (_) => const DashboardView());

      case attendanceScreen:
        return MaterialPageRoute(builder: (_) => AttendanceScreen());

      case addNew:
        return MaterialPageRoute(builder: (_) => NewEntryScreen());

      case record:
        return MaterialPageRoute(builder: (_) => const RecordAchievementPage());

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found'))),
        );
    }
  }
}
