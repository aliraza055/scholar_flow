import 'package:flutter/material.dart';
import 'package:scholar_flow/Services/performance_services.dart';

class PerformanceAnalyticsPage extends StatefulWidget {
  const PerformanceAnalyticsPage({super.key});

  @override
  State<PerformanceAnalyticsPage> createState() =>
      _PerformanceAnalyticsPageState();
}

class _PerformanceAnalyticsPageState extends State<PerformanceAnalyticsPage> {
  final _service = PerformanceService();

  late Future<BatchStats> _statsFuture;
  late Future<List<SubjectProficiency>> _proficiencyFuture;
  late Future<List<AtRiskStudent>> _atRiskFuture;
  late Future<AttendanceStats> _attendanceFuture;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  // ── Assign cached futures ──────────────────────────────────────────────
  void _loadData() {
    _statsFuture = _service.getBatchStats();
    _proficiencyFuture = _service.getSubjectProficiency();
    _atRiskFuture = _service.getAtRiskStudents();
    _attendanceFuture = _service.getAttendanceStats();
  }

  // ── Pull-to-refresh: bust cache then reload ────────────────────────────
  Future<void> _onRefresh() async {
    _service.invalidateCache();
    setState(_loadData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          color: const Color(0xFF1A73E8),
          displacement: 20,
          child: CustomScrollView(
            physics: const AlwaysScrollableScrollPhysics(
              parent: BouncingScrollPhysics(),
            ),
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // ── Attendance ──
                          FutureBuilder<AttendanceStats>(
                            future: _attendanceFuture,
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return _shimmerCard(height: 110);
                              }
                              return _AttendanceCard(
                                stats:
                                    snap.data ??
                                    AttendanceStats(averagePercentage: 0),
                              );
                            },
                          ),
                          const SizedBox(height: 16),

                          // ── Batch Performance ──
                          FutureBuilder<BatchStats>(
                            future: _statsFuture,
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return _shimmerCard(height: 200, dark: true);
                              }
                              return _BatchPerformanceCard(
                                stats:
                                    snap.data ??
                                    BatchStats(
                                      totalStudents: 0,
                                      averageGPA: 0,
                                      topScore: 0,
                                      passRate: 0,
                                    ),
                              );
                            },
                          ),
                          const SizedBox(height: 28),

                          // ── Subject Proficiency ──
                          const _SectionHeader(title: 'Subject Proficiency'),
                          const SizedBox(height: 14),
                          FutureBuilder<List<SubjectProficiency>>(
                            future: _proficiencyFuture,
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return _shimmerCard(height: 160);
                              }
                              if (!snap.hasData || snap.data!.isEmpty) {
                                return const _EmptyDataCard(
                                  message:
                                      'No marks data yet. Add student marks to see proficiency.',
                                );
                              }
                              return _SubjectProficiencyCard(
                                subjects: snap.data!,
                              );
                            },
                          ),
                          const SizedBox(height: 28),

                          // ── At Risk ──
                          FutureBuilder<List<AtRiskStudent>>(
                            future: _atRiskFuture,
                            builder: (ctx, snap) {
                              if (snap.connectionState ==
                                  ConnectionState.waiting) {
                                return const SizedBox.shrink();
                              }
                              if (!snap.hasData || snap.data!.isEmpty) {
                                return const SizedBox.shrink();
                              }
                              return _AtRiskCard(students: snap.data!);
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ── Gradient Header ──────────────────────────────────────────────────────
  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1A73E8), Color(0xFF0D47A1)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(30)),
      ),
      child: Stack(
        children: [
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.insights_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Performance Analytics',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 21,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Real-time academic overview and attendance benchmarks.',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.65),
                        fontSize: 13,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Loading placeholder ─────────────────────────────────────────────────
  Widget _shimmerCard({required double height, bool dark = false}) {
    return Container(
      width: double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: dark ? const Color(0xff0d5c7d) : Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Center(
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: dark ? Colors.white : const Color(0xFF1A73E8),
        ),
      ),
    );
  }
}

// ── Section Header ─────────────────────────────────────────────────────────

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

// ── Attendance Card ────────────────────────────────────────────────────────

class _AttendanceCard extends StatelessWidget {
  final AttendanceStats stats;
  const _AttendanceCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    final pct = stats.averagePercentage;

    final Color color = pct >= 75
        ? const Color(0xff0d5c7d)
        : pct >= 50
        ? const Color(0xFFF59E0B)
        : const Color(0xFFEF4444);

    final String label = pct == 0
        ? 'No data'
        : pct >= 75
        ? 'Good Standing'
        : pct >= 50
        ? 'Needs Improvement'
        : 'Critical';

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // ── Left: Ring ──
          SizedBox(
            width: 90,
            height: 90,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Track
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: 1.0,
                    strokeWidth: 8,
                    color: color.withOpacity(0.10),
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Progress
                SizedBox(
                  width: 90,
                  height: 90,
                  child: CircularProgressIndicator(
                    value: pct / 100,
                    strokeWidth: 8,
                    backgroundColor: Colors.transparent,
                    color: color,
                    strokeCap: StrokeCap.round,
                  ),
                ),
                // Center text
                Text(
                  pct == 0 ? '—' : '${pct.toStringAsFixed(0)}%',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                    color: Color(0xff5fa8d3),
                    letterSpacing: -0.8,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // ── Right: Details ──
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ATTENDANCE',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B2A),

                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 2),
                const Text(
                  'Average Rate',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF94A3B8),
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    _MiniStat(
                      label: 'Present',
                      value: pct == 0 ? '—' : '${pct.toStringAsFixed(0)}%',
                      color: const Color(0xFF14B870),
                    ),
                    const SizedBox(width: 16),
                    _MiniStat(
                      label: 'Absent',
                      value: pct == 0
                          ? '—'
                          : '${(100 - pct).toStringAsFixed(0)}%',
                      color: const Color(0xFFEF4444),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.09),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: color.withOpacity(0.22)),
                  ),
                  child: Text(
                    label,
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: color,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini Stat ─────────────────────────────────────────────────────────────────

class _MiniStat extends StatelessWidget {
  final String label;
  final String value;
  final Color color;
  const _MiniStat({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: color,
            letterSpacing: -0.3,
          ),
        ),
        Text(
          label,
          style: const TextStyle(
            fontSize: 10,
            color: Color(0xFF94A3B8),
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

// ── Batch Performance Card ─────────────────────────────────────────────────

class _BatchPerformanceCard extends StatelessWidget {
  final BatchStats stats;
  const _BatchPerformanceCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xff0d5c7d), Color(0xff5fa8d3)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1A73E8).withOpacity(0.35),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Stack(
        children: [
          Positioned(
            right: -10,
            top: -10,
            child: Container(
              width: 90,
              height: 90,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.08),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'MARKS SUMMARY',
                          style: TextStyle(
                            color: Colors.white60,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 1.2,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Batch Performance',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.insights_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Row 1
              Row(
                children: [
                  _StatBox(label: 'AVG SCORE', value: '${stats.averageGPA}%'),
                  _VertDivider(),
                  _StatBox(label: 'TOP SCORE', value: '${stats.topScore}%'),
                ],
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: Colors.white.withOpacity(0.15)),
              const SizedBox(height: 14),
              // Row 2
              Row(
                children: [
                  _StatBox(label: 'PASS RATE', value: '${stats.passRate}%'),
                  _VertDivider(),
                  _StatBox(label: 'STUDENTS', value: '${stats.totalStudents}'),
                ],
              ),
              const SizedBox(height: 14),
              Container(height: 1, color: Colors.white.withOpacity(0.15)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF2ECC71),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 7),
                  const Text(
                    'Live data from Firestore',
                    style: TextStyle(color: Colors.white54, fontSize: 11),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  const _StatBox({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              color: Colors.white54,
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.8,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
            ),
          ),
        ],
      ),
    );
  }
}

class _VertDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 40,
      margin: const EdgeInsets.symmetric(horizontal: 16),
      color: Colors.white.withOpacity(0.2),
    );
  }
}

// ── Subject Proficiency Card ───────────────────────────────────────────────

class _SubjectProficiencyCard extends StatelessWidget {
  final List<SubjectProficiency> subjects;
  const _SubjectProficiencyCard({required this.subjects});

  static const _colors = [
    Color(0xFF1A73E8),
    Color(0xFF7C3AED),
    Color(0xFF10B981),
    Color(0xFFF59E0B),
    Color(0xFFEF4444),
    Color(0xFF06B6D4),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: subjects.asMap().entries.map((e) {
          final color = _colors[e.key % _colors.length];
          final isLast = e.key == subjects.length - 1;
          return Padding(
            padding: EdgeInsets.only(bottom: isLast ? 0 : 18),
            child: _SubjectBar(
              subject: e.value.subject,
              average: e.value.average,
              color: color,
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _SubjectBar extends StatelessWidget {
  final String subject;
  final double average;
  final Color color;
  const _SubjectBar({
    required this.subject,
    required this.average,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                subject,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF0D1B2A),
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${average.toStringAsFixed(1)}%',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: LinearProgressIndicator(
            value: average / 100,
            backgroundColor: color.withOpacity(0.1),
            color: color,
            minHeight: 7,
          ),
        ),
      ],
    );
  }
}

// ── At Risk Card ───────────────────────────────────────────────────────────

class _AtRiskCard extends StatelessWidget {
  final List<AtRiskStudent> students;
  const _AtRiskCard({required this.students});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.045),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: const Icon(
                  Icons.warning_amber_rounded,
                  color: Color(0xFFEF4444),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Attention Needed',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF0D1B2A),
                      ),
                    ),
                    Text(
                      'Students scoring below 50%',
                      style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${students.length} student${students.length > 1 ? 's' : ''}',
                  style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: const Color(0xFFF0F2F5)),
          const SizedBox(height: 12),
          ...students.asMap().entries.map((e) {
            final isLast = e.key == students.length - 1;
            return Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 10),
              child: _AtRiskTile(student: e.value),
            );
          }),
        ],
      ),
    );
  }
}

class _AtRiskTile extends StatelessWidget {
  final AtRiskStudent student;
  const _AtRiskTile({required this.student});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(13),
      decoration: BoxDecoration(
        color: const Color(0xFFEF4444).withOpacity(0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEF4444).withOpacity(0.12)),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(
                student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFEF4444),
                ),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  student.name,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  student.reason,
                  style: const TextStyle(
                    fontSize: 11,
                    color: Color(0xFFEF4444),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Text(
              'Schedule',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A73E8),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ── Empty Data Card ────────────────────────────────────────────────────────

class _EmptyDataCard extends StatelessWidget {
  final String message;
  const _EmptyDataCard({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Icon(
              Icons.bar_chart_rounded,
              color: Color(0xFF1A73E8),
              size: 28,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            message,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Color(0xFF64748B),
              fontSize: 13,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}
