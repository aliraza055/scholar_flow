import 'package:flutter/material.dart';
import 'package:scholar_flow/screens/attendance_sheet.dart';
import 'package:scholar_flow/screens/dashboard_screen.dart';
import 'package:scholar_flow/screens/new_entry.dart';
import 'package:scholar_flow/screens/onboard.dart';
import 'package:scholar_flow/screens/performance_analysis.dart';
import 'package:scholar_flow/screens/record_achivement.dart';
import 'package:scholar_flow/screens/sign-up.dart';
import 'package:scholar_flow/screens/sing_in.dart';
import 'package:scholar_flow/screens/students_list.dart';
import 'package:scholar_flow/widgets/bottom_nav.dart';

class AppRouters {
  static const appOnboarding = '/';
  static const signIn = '/signIn';
  static const signUP = '/signUp';
  static const dashScreen = '/dashboard';
  static const bottomNav = '/bottomNav';
  static const attendanceScreen = '/attendance';
  static const addNew = '/addNew';
  static const record = '/record';
  static const performance = '/performance';
  static const students = '/students';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case appOnboarding:
        return MaterialPageRoute(
          builder: (_) => const WelcomeScreen(), // check name exists
        );
      case signIn:
        return MaterialPageRoute(builder: (_) => const SignInScreen());
      case signUP:
        return MaterialPageRoute(builder: (_) => const SignUpScreen());
      case dashScreen:
        return MaterialPageRoute(builder: (_) => const DashboardView());
      case bottomNav:
        return MaterialPageRoute(builder: (_) => const DashboardBottomNav());
      case attendanceScreen:
        return MaterialPageRoute(builder: (_) => AttendanceScreen());
      case students:
        return MaterialPageRoute(builder: (_) => Students());
      case addNew:
        return MaterialPageRoute(builder: (_) => NewEntryScreen());

      case performance:
        return MaterialPageRoute(builder: (_) => PerformanceAnalyticsPage());

      case record:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => AddMarksPage(
            studentId: args?['studentId'] ?? '',
            studentName: args?['studentName'] ?? '',
          ),
        );

      default:
        return MaterialPageRoute(
          builder: (_) =>
              const Scaffold(body: Center(child: Text('Route not found!'))),
        );
    }
  }
}
