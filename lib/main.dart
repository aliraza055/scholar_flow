import 'package:flutter/material.dart';
import 'package:scholar_flow/screens/attendance_sheet.dart';
import 'package:scholar_flow/screens/dashboard_screen.dart';
import 'package:scholar_flow/screens/new_entry.dart';
import 'package:scholar_flow/screens/onboard.dart';
import 'package:scholar_flow/screens/performance_analysis.dart';
import 'package:scholar_flow/screens/record_achivement.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/dash': (context) => DashboardView(),
        '/attendance': (context) => AttendanceScreen(),
        '/performance': (context) => PerformanceAnalyticsPage(),
        '/addNew': (context) => NewEntryScreen(),
        '/marks': (context) => RecordAchievementPage(),
      },
    );
  }
}
