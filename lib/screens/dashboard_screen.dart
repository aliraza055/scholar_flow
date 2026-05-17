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
            // const _SectionHeader(title: 'Quick Actions'),
            //  const SizedBox(height: 14),
            Row(
              children: [
                Container(
                  width: 4,
                  height: 18,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF0F2041), Color(0xFF1A3A6E)],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
                const SizedBox(width: 10),
                const Text(
                  'Quick Actions',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B2A),
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // ── Add Student ───────────────────────────────────────────
            SimpleTile(
              title: 'Add Student',
              subtitle: 'Enroll new scholars into the system',
              icon: Icons.person_add_rounded,
              iconBgColor: const Color(0xFFE8F5E9),
              iconColor: const Color(0xFF0F9E7B),
              onTap: () => Navigator.pushNamed(context, AppRouters.addNew),
            ),
            const SizedBox(height: 10),

            // ── Enter Marks ───────────────────────────────────────────
            SimpleTile(
              title: 'Enter Marks',
              subtitle: 'Record Mid-term & Final exam marks',
              icon: Icons.edit_note_rounded,
              iconBgColor: const Color(0xFFFFF3E0),
              iconColor: const Color(0xFFD4522A),
              onTap: () => Navigator.pushNamed(context, AppRouters.students),
            ),
            const SizedBox(height: 10),

            // ── Manage Students ───────────────────────────────────────
            SimpleTile(
              title: 'Manage Students',
              subtitle: 'Edit or remove student records',
              icon: Icons.group_rounded,
              iconBgColor: const Color(0xFFEDE7F6),
              iconColor: const Color(0xFF7C3AED),
              onTap: () => Navigator.pushNamed(context, AppRouters.manage),
            ),
            const SizedBox(height: 10),

            // ── View Performance ──────────────────────────────────────
            SimpleTile(
              title: 'View Performance',
              subtitle: 'Analytics for Mid-term results',
              icon: Icons.trending_up_rounded,
              iconBgColor: const Color(0xFFE8EAF6),
              iconColor: const Color(0xFF3B5FD4),
              onTap: () => Navigator.pushNamed(context, AppRouters.performance),
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
