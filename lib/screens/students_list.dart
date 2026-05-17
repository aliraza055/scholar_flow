import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
import 'package:scholar_flow/Models/student_model.dart';
import 'package:scholar_flow/Services/firebase_services.dart';
import 'package:scholar_flow/widgets/student_card.dart';

class Students extends StatefulWidget {
  const Students({super.key});

  @override
  State<Students> createState() => _StudentsState();
}

class _StudentsState extends State<Students> {
  final FirebaseServices _service = FirebaseServices();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: StreamBuilder<List<StudentModel>>(
        stream: _service.streamStudents(),
        builder: (context, snapshot) {
          final students = snapshot.data ?? [];
          final count = students.length;

          // ── Apply search filter ──
          final filtered = students.where((s) {
            if (_searchQuery.isEmpty) return true;
            return s.name.toLowerCase().contains(_searchQuery) ||
                s.rollNo.toLowerCase().contains(_searchQuery);
          }).toList();

          return Column(
            children: [
              // ── Gradient Header ──
              _Header(count: count),

              // ── Floating Search Bar ──
              _SearchBar(
                onChanged: (v) =>
                    setState(() => _searchQuery = v.toLowerCase()),
              ),
              const SizedBox(height: 12),

              // ── Section Label ──
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  children: [
                    Container(
                      width: 4,
                      height: 16,
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
                      'All Students',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D1B2A),
                      ),
                    ),
                    const Spacer(),
                    Text(
                      '$count total',
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // ── List / States ──
              Expanded(child: _buildBody(snapshot, filtered)),
            ],
          );
        },
      ),
    );
  }

  Widget _buildBody(
    AsyncSnapshot<List<StudentModel>> snapshot,
    List<StudentModel> filtered,
  ) {
    // Loading
    if (snapshot.connectionState == ConnectionState.waiting) {
      return const _LoadingState();
    }

    // Error
    if (snapshot.hasError) {
      return const _EmptyState(
        icon: Icons.cloud_off_rounded,
        title: 'Unable to load students',
        subtitle: 'Please check your connection and try again.',
      );
    }

    // No students at all
    if (!snapshot.hasData || snapshot.data!.isEmpty) {
      return const _EmptyState(
        icon: Icons.school_outlined,
        title: 'No students yet',
        subtitle: 'Add students to start entering marks.',
      );
    }

    // Search returned nothing
    if (filtered.isEmpty) {
      return const _EmptyState(
        icon: Icons.search_off_rounded,
        title: 'No matches found',
        subtitle: 'Try adjusting your search keywords.',
      );
    }

    // List
    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
      physics: const BouncingScrollPhysics(),
      itemCount: filtered.length,
      itemBuilder: (context, index) {
        final student = filtered[index];
        return StudentCard(
          student: student,
          index: index,
          onTap: () => Navigator.pushNamed(
            context,
            AppRouters.record,
            arguments: {'studentId': student.id, 'studentName': student.name},
          ),
        );
      },
    );
  }
}

// ── Gradient Header ────────────────────────────────────────────────────────

class _Header extends StatelessWidget {
  final int count;
  const _Header({required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 36, 20, 36),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF0F2041), Color(0xFF1A3A6E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
          // ── Decorative circles ──
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.07),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          // ── Content ──
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Icon
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.assignment_ind_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const Spacer(),
                  // Live count badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFF2ECC71),
                            shape: BoxShape.circle,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$count Enrolled',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),
              const Text(
                'Add Marks of Students',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Select a student to manage their marks and academic records.',
                style: TextStyle(
                  color: Colors.white.withOpacity(0.65),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Floating Search Bar ────────────────────────────────────────────────────

class _SearchBar extends StatelessWidget {
  final ValueChanged<String> onChanged;
  const _SearchBar({required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: const Offset(0, -20),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Container(
          height: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF1A73E8).withOpacity(0.12),
                blurRadius: 20,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              const Padding(
                padding: EdgeInsets.only(left: 16, right: 10),
                child: Icon(
                  Icons.search_rounded,
                  color: Color(0xFF9AA6B2),
                  size: 20,
                ),
              ),
              Expanded(
                child: TextField(
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 14,
                    color: Color(0xFF0D1B2A),
                  ),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Search by name or roll number…',
                    hintStyle: TextStyle(
                      color: Color(0xFF9AA6B2),
                      fontSize: 14,
                    ),
                    contentPadding: EdgeInsets.symmetric(vertical: 15),
                    isDense: true,
                  ),
                ),
              ),
              // Filter icon
              Container(
                margin: const EdgeInsets.only(right: 10),
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xFFEBF3FE),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: Color(0xFF1A73E8),
                  size: 18,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;

  const _EmptyState({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 40),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: const Color(0xFF1A73E8).withOpacity(0.08),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(icon, size: 36, color: const Color(0xFF1A73E8)),
            ),
            const SizedBox(height: 20),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 13,
                color: Color(0xFF64748B),
                height: 1.4,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Loading State ──────────────────────────────────────────────────────────

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        strokeWidth: 2.5,
        color: Color(0xFF1A73E8),
      ),
    );
  }
}
