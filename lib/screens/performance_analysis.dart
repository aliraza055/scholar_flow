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
  // ✅ alag future

  @override
  void initState() {
    super.initState();
    _statsFuture = _service.getBatchStats();
    _proficiencyFuture = _service.getSubjectProficiency();
    _atRiskFuture = _service.getAtRiskStudents();
    _attendanceFuture = _service.getAttendanceStats(); // ✅ alag future
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              // ── Header ──
              const Text(
                "Performance Analytics",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939),
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Real-time academic oversight. Review student progress and attendance benchmarks.",
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 24),

              // ── Attendance Card ──
              FutureBuilder<AttendanceStats>(
                future: _attendanceFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildAttendanceLoading();
                  }
                  final stats =
                      snapshot.data ?? AttendanceStats(averagePercentage: 0);
                  return _buildAttendanceCard(stats);
                },
              ),
              const SizedBox(height: 20),

              // ── Batch Performance Card ──
              FutureBuilder<BatchStats>(
                future: _statsFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return _buildBatchLoadingCard();
                  }
                  final stats =
                      snapshot.data ??
                      BatchStats(
                        totalStudents: 0,
                        averageGPA: 0,
                        topScore: 0,
                        passRate: 0,
                      );
                  return _buildBatchPerformanceCard(stats);
                },
              ),
              const SizedBox(height: 30),

              // ── Subject Proficiency ──
              const Text(
                "Subject Proficiency",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1D2939),
                ),
              ),
              const SizedBox(height: 15),

              FutureBuilder<List<SubjectProficiency>>(
                future: _proficiencyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: Padding(
                        padding: EdgeInsets.all(24),
                        child: CircularProgressIndicator(
                          color: Color(0xFF006692),
                        ),
                      ),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Center(
                        child: Text(
                          'Koi marks data nahi hai.\nPehle students ke marks add karo.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  final colors = [
                    Colors.blue,
                    Colors.deepPurple,
                    Colors.blueGrey,
                    Colors.redAccent,
                    Colors.teal,
                    Colors.orange,
                  ];

                  return Column(
                    children: snapshot.data!.asMap().entries.map((entry) {
                      final i = entry.key;
                      final s = entry.value;
                      return _buildSubjectBar(
                        s.subject,
                        s.average / 100,
                        colors[i % colors.length],
                      );
                    }).toList(),
                  );
                },
              ),

              const SizedBox(height: 30),

              // ── Attention Needed ── ✅ Ab alag Future use ho raha hai
              FutureBuilder<List<AtRiskStudent>>(
                future: _atRiskFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SizedBox();
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const SizedBox();
                  }

                  return Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(6),
                              decoration: const BoxDecoration(
                                color: Colors.redAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.warning_amber_rounded,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                            const SizedBox(width: 10),
                            const Text(
                              "Attention Needed",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        ...snapshot.data!.map(
                          (s) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: _buildAttentionTile(s.name, s.reason),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 100),
            ],
          ),
        ),
      ),
    );
  }

  // ── Attendance Card ──────────────────────────────────────────────────────
  Widget _buildAttendanceLoading() {
    return Container(
      width: double.infinity,
      height: 210,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Color(0xFF006692)),
      ),
    );
  }

  Widget _buildAttendanceCard(AttendanceStats stats) {
    final pct = stats.averagePercentage;

    // Color: green ≥75%, orange 50-74%, red <50%
    final Color ringColor = pct >= 75
        ? Colors.blue
        : pct >= 50
        ? Colors.orange
        : Colors.redAccent;

    // Status label
    final String statusLabel = pct >= 75
        ? "Good Standing"
        : pct >= 50
        ? "Needs Improvement"
        : "Critical — Below 50%";

    final Color statusColor = pct >= 75
        ? Colors.green
        : pct >= 50
        ? Colors.orange
        : Colors.red;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
        ],
      ),
      child: Column(
        children: [
          const Text(
            "ATTENDANCE PERCENTAGE",
            style: TextStyle(
              letterSpacing: 1.2,
              color: Colors.grey,
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Stack(
            alignment: Alignment.center,
            children: [
              SizedBox(
                height: 120,
                width: 120,
                child: CircularProgressIndicator(
                  value: pct / 100,
                  strokeWidth: 10,
                  backgroundColor: ringColor.withOpacity(0.15),
                  color: ringColor,
                ),
              ),
              Column(
                children: [
                  Text(
                    pct == 0 ? "—" : "${pct.toStringAsFixed(1)}%",
                    style: const TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Text(
                    "Average",
                    style: TextStyle(color: Colors.grey, fontSize: 12),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: statusColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              pct == 0 ? "No attendance data yet" : statusLabel,
              style: TextStyle(
                color: pct == 0 ? Colors.grey : statusColor,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildAttendanceCard() {
  //   return Container(
  //     width: double.infinity,
  //     padding: const EdgeInsets.all(24),
  //     decoration: BoxDecoration(
  //       color: Colors.white,
  //       borderRadius: BorderRadius.circular(20),
  //       boxShadow: [
  //         BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 10),
  //       ],
  //     ),
  //     child: Column(
  //       children: [
  //         const Text(
  //           "ATTENDANCE PERCENTAGE",
  //           style: TextStyle(
  //             letterSpacing: 1.2,
  //             color: Colors.grey,
  //             fontSize: 12,
  //             fontWeight: FontWeight.bold,
  //           ),
  //         ),
  //         const SizedBox(height: 20),
  //         Stack(
  //           alignment: Alignment.center,
  //           children: [
  //             SizedBox(
  //               height: 120,
  //               width: 120,
  //               child: CircularProgressIndicator(
  //                 value: 0.92,
  //                 strokeWidth: 10,
  //                 backgroundColor: Colors.blue.withOpacity(0.2),
  //                 color: Colors.blue,
  //               ),
  //             ),
  //             const Column(
  //               children: [
  //                 Text(
  //                   "92%",
  //                   style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
  //                 ),
  //                 Text(
  //                   "Average",
  //                   style: TextStyle(color: Colors.grey, fontSize: 12),
  //                 ),
  //               ],
  //             ),
  //           ],
  //         ),
  //         const SizedBox(height: 20),
  //         Container(
  //           padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //           decoration: BoxDecoration(
  //             color: Colors.red.withOpacity(0.1),
  //             borderRadius: BorderRadius.circular(20),
  //           ),
  //           child: const Text(
  //             "↘ -2.4% from last month",
  //             style: TextStyle(
  //               color: Colors.red,
  //               fontWeight: FontWeight.bold,
  //               fontSize: 12,
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // ── Batch Loading Card ───────────────────────────────────────────────────

  Widget _buildBatchLoadingCard() {
    return Container(
      width: double.infinity,
      height: 200,
      decoration: BoxDecoration(
        color: const Color(0xFF006692),
        borderRadius: BorderRadius.circular(24),
      ),
      child: const Center(
        child: CircularProgressIndicator(color: Colors.white),
      ),
    );
  }

  // ── Batch Performance Card ───────────────────────────────────────────────

  Widget _buildBatchPerformanceCard(BatchStats stats) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF006692),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "MARKS SUMMARY",
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Overall Batch\nPerformance",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.insights, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 24),
          GridView.count(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisCount: 2,
            childAspectRatio: 2.5,
            children: [
              _buildStat("AVERAGE GPA", stats.averageGPA.toString()),
              _buildStat("TOP GPA", stats.topScore.toString()),
              _buildStat("PASS RATE", "${stats.passRate}%"),
              _buildStat("STUDENTS", stats.totalStudents.toString()),
            ],
          ),
          const Divider(color: Colors.white24),
          const SizedBox(height: 8),
          const Text(
            "Live data from Firestore",
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
        ],
      ),
    );
  }

  // ── Subject Bar ──────────────────────────────────────────────────────────

  Widget _buildSubjectBar(String title, double progress, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 15),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(title, style: const TextStyle(fontWeight: FontWeight.w500)),
              Text(
                "${(progress * 100).toStringAsFixed(1)}%",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: progress,
            backgroundColor: Colors.grey.shade200,
            color: color,
            minHeight: 8,
            borderRadius: BorderRadius.circular(10),
          ),
        ],
      ),
    );
  }

  // ── Stat Box ─────────────────────────────────────────────────────────────

  Widget _buildStat(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 10),
        ),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  // ── Attention Tile ───────────────────────────────────────────────────────

  Widget _buildAttentionTile(String name, String alert) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF006692).withOpacity(0.15),
            radius: 18,
            child: Text(
              name.isNotEmpty ? name[0].toUpperCase() : '?',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: Color(0xFF006692),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
                Text(
                  alert,
                  style: const TextStyle(color: Colors.red, fontSize: 12),
                ),
                const SizedBox(height: 4),
                const Text(
                  "Schedule Meeting",
                  style: TextStyle(
                    color: Colors.blue,
                    fontSize: 12,
                    decoration: TextDecoration.underline,
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
