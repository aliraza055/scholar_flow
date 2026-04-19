import 'package:flutter/material.dart';
import 'package:scholar_flow/widgets/action_card.dart';
import 'package:scholar_flow/widgets/bottom_nav.dart';
import 'package:scholar_flow/widgets/dashboard_header.dart';
import 'package:scholar_flow/widgets/overview.dart';
import 'package:scholar_flow/widgets/simple_title.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F8FA),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              DashboardHeader(),
              SizedBox(height: 24),

              ActionCard(
                title: 'Mark Attendance',
                subtitle:
                    'Record student presence for the morning session. 3 classes pending.',
                buttonText: 'Start Session',
                ontap: () {},
                icon: Icons.calendar_today,
              ),

              SizedBox(height: 16),

              GestureDetector(
                onTap: () {},
                child: SimpleTile(
                  title: 'View Performance',
                  subtitle: 'Analytics for Mid-term results',
                  icon: Icons.trending_up,
                  backgroundColor: Color(0xFFEFF2FF),
                ),
              ),

              SizedBox(height: 16),

              GestureDetector(
                onTap: () {},
                child: SimpleTile(
                  title: 'Add Student',
                  subtitle: 'Enroll new scholars',
                  icon: Icons.person_add,
                  backgroundColor: Color(0xFFEFFAF0),
                ),
              ),

              SizedBox(height: 12),

              GestureDetector(
                onTap: () {},
                child: SimpleTile(
                  title: 'Enter Assignment Marks',
                  subtitle: 'Grade homework',
                  icon: Icons.assignment,
                  backgroundColor: Color(0xFFFFF4E6),
                ),
              ),

              SizedBox(height: 12),

              SimpleTile(
                title: 'Enter Quiz Marks',
                subtitle: 'Flash test results',
                icon: Icons.quiz,
                backgroundColor: Color(0xFFF5EEFF),
              ),

              SizedBox(height: 24),

              Text(
                'Daily Overview',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),

              SizedBox(height: 16),

              OverviewSection(),
            ],
          ),
        ),
      ),
    );
  }
}
