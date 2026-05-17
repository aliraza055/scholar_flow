import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
import 'package:scholar_flow/widgets/action_card.dart';
import 'package:scholar_flow/widgets/app_bar.dart';
import 'package:scholar_flow/widgets/dashboard_header.dart';
import 'package:scholar_flow/widgets/overview.dart';
import 'package:scholar_flow/widgets/simple_title.dart';

class DashboardView extends StatefulWidget {
  const DashboardView({super.key});

  @override
  State<DashboardView> createState() => _DashboardViewState();
}

class _DashboardViewState extends State<DashboardView> {
  User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      appBar: const CustomAppBar(),
      backgroundColor: const Color(0xFFF4F6FA),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Welcome Hero ──
            DashboardHeader(name: user?.displayName ?? 'Teacher'),
            const SizedBox(height: 24),

            // ── Primary Action ──
            ActionCard(
              title: 'Mark Attendance',
              subtitle:
                  "Record student presence for today's session. 3 classes pending.",
              buttonText: 'Start Session',
              ontap: () =>
                  Navigator.pushNamed(context, AppRouters.attendanceScreen),
              icon: Icons.calendar_today_rounded,
            ),
            const SizedBox(height: 28),

            // ── Quick Actions ──
            const _SectionHeader(title: 'Quick Actions'),
            const SizedBox(height: 14),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouters.addNew),
              child: const SimpleTile(
                title: 'Add Student',
                subtitle: 'Enroll new scholars into the system',
                icon: Icons.person_add_rounded,
                backgroundColor: Color(0xFFEFFAF0),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouters.students),
              child: const SimpleTile(
                title: 'Enter Marks',
                subtitle: 'Record Mid-term & Final exam marks',
                icon: Icons.assignment_rounded,
                backgroundColor: Color(0xFFFFF4E6),
              ),
            ),
            const SizedBox(height: 10),

            GestureDetector(
              onTap: () => Navigator.pushNamed(context, AppRouters.performance),
              child: const SimpleTile(
                title: 'View Performance',
                subtitle: 'Analytics for Mid-term results',
                icon: Icons.trending_up_rounded,
                backgroundColor: Color(0xFFEFF2FF),
              ),
            ),
            const SizedBox(height: 28),

            // ── Daily Overview ──
            const _SectionHeader(title: 'Daily Overview'),
            const SizedBox(height: 14),

            OverviewSection(),
          ],
        ),
      ),
    );
  }
}

// ── Reusable Section Header ────────────────────────────────────────────────

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 4,
          height: 18,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ),
            borderRadius: BorderRadius.circular(2),
          ),
        ),
        const SizedBox(width: 10),
        Text(
          title,
          style: const TextStyle(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            color: Color(0xFF0D1B2A),
            letterSpacing: -0.2,
          ),
        ),
      ],
    );
  }
}
