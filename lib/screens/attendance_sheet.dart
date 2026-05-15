import 'package:flutter/material.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:scholar_flow/Models/attendance_model.dart';
import 'package:scholar_flow/Models/student_model.dart';
import 'package:scholar_flow/Services/firebase_services.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseServices _service = FirebaseServices();

  // ── FIX 2: Har student ka apna ValueNotifier — sirf wahi card rebuild hoga ──
  // studentId → ValueNotifier<AttendanceStatus>
  final Map<String, ValueNotifier<AttendanceStatus>> _notifiers = {};

  bool _isSubmitting = false;
  bool _alreadySubmitted = false;

  // ── FIX 1: Guard flag — students sirf ek baar initialize honge ──
  bool _studentsInitialized = false;
  List<StudentModel> _students = [];

  // presentCount track karne ke liye alag notifier (header ko update karna hai)
  final ValueNotifier<int> _presentCount = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _checkTodaySubmission();
  }

  @override
  void dispose() {
    // Sab notifiers dispose karo — memory leak se bachao
    for (final n in _notifiers.values) {
      n.dispose();
    }
    _presentCount.dispose();
    super.dispose();
  }

  Future<void> _checkTodaySubmission() async {
    final done = await _service.isAttendanceSubmittedToday();
    if (mounted) setState(() => _alreadySubmitted = done);
  }

  /// ── FIX 1: Sirf pehli baar initialize karo ──────────────────────────────
  void _initStudentsOnce(List<StudentModel> incoming) {
    if (_studentsInitialized) return; // dobara mat chalao

    _students = incoming;
    for (final s in incoming) {
      final notifier = ValueNotifier(AttendanceStatus.absent);
      notifier.addListener(_recalcPresentCount);
      _notifiers[s.id] = notifier;
    }
    _recalcPresentCount();
    _studentsInitialized = true;
  }

  void _recalcPresentCount() {
    _presentCount.value = _notifiers.values
        .where((n) => n.value == AttendanceStatus.present)
        .length;
  }

  Future<void> _submitAttendance() async {
    setState(() => _isSubmitting = true);

    // Map<studentId, AttendanceStatus> banaao notifiers se
    final attendanceMap = {
      for (final entry in _notifiers.entries) entry.key: entry.value.value,
    };

    try {
      await _service.submitAttendance(attendanceMap: attendanceMap);
      // ── FIX 1: Success ke baad permanently lock ──
      setState(() {
        _alreadySubmitted = true;
        _isSubmitting = false;
      });
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance submitted successfully!'),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final today = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    return Scaffold(
      backgroundColor: const Color(0xFFEAF1F8),
      body: SafeArea(
        child: StreamBuilder<List<StudentModel>>(
          stream: _service.streamStudents(),
          builder: (context, snapshot) {
            // ── FIX 1: Sirf ek baar initialize ──
            if (snapshot.hasData) _initStudentsOnce(snapshot.data!);

            final students = _students;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ────────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 24, 24, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Class Attendance',
                        style: TextStyle(
                          fontSize: 26,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF1A2433),
                          letterSpacing: -0.5,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        "Mark today's session presence",
                        style: TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7A8D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Stats Row — presentCount sirf yahan update hoga ───────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _presentCount,
                    builder: (_, count, __) {
                      return Row(
                        children: [
                          _StatChip(
                            icon: Icons.people_rounded,
                            label: '${students.length} Enrolled',
                            color: const Color(0xFF1B5E8C),
                          ),
                          const SizedBox(width: 10),
                          _StatChip(
                            icon: Icons.check_circle_outline_rounded,
                            label: '$count Present',
                            color: const Color(0xFF2ECC71),
                          ),
                          const SizedBox(width: 10),
                          _StatChip(
                            icon: Icons.calendar_today_rounded,
                            label: today,
                            color: const Color(0xFF6B7A8D),
                          ),
                        ],
                      );
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // ── Already submitted banner ──────────────────────────────
                if (_alreadySubmitted)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFF2ECC71).withOpacity(0.12),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                          color: const Color(0xFF2ECC71).withOpacity(0.3),
                        ),
                      ),
                      child: const Row(
                        children: [
                          Icon(
                            Icons.check_circle_rounded,
                            color: Color(0xFF2ECC71),
                            size: 18,
                          ),
                          SizedBox(width: 8),
                          Text(
                            "Today's attendance already submitted",
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: Color(0xFF1A6B3C),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                const SizedBox(height: 8),

                // ── Student List ──────────────────────────────────────────
                Expanded(
                  child:
                      snapshot.connectionState == ConnectionState.waiting &&
                          !_studentsInitialized
                      ? const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF1B5E8C),
                            strokeWidth: 2.5,
                          ),
                        )
                      : students.isEmpty
                      ? const Center(
                          child: Text(
                            'No students found',
                            style: TextStyle(color: Color(0xFF6B7A8D)),
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
                          itemCount: students.length,
                          itemBuilder: (context, index) {
                            final student = students[index];
                            final notifier = _notifiers[student.id]!;

                            // ── FIX 2: Sirf is card ka notifier listen ──
                            return _AttendanceCard(
                              key: ValueKey(student.id),
                              student: student,
                              index: index,
                              notifier: notifier,
                              disabled: _alreadySubmitted,
                            );
                          },
                        ),
                ),

                // ── Submit Button ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: ValueListenableBuilder<int>(
                    valueListenable: _presentCount,
                    builder: (_, count, __) {
                      return SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed:
                              (_alreadySubmitted ||
                                  _isSubmitting ||
                                  students.isEmpty)
                              ? null
                              : _submitAttendance,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF1B5E8C),
                            disabledBackgroundColor: const Color(
                              0xFF1B5E8C,
                            ).withOpacity(0.4),
                            foregroundColor: Colors.white,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28),
                            ),
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  width: 22,
                                  height: 22,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  _alreadySubmitted
                                      ? 'Already Submitted'
                                      : 'Submit Attendance  ($count/${students.length})',
                                  style: const TextStyle(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}

// ─── Attendance Card — apna khud ka ValueNotifier sunta hai ──────────────────

class _AttendanceCard extends StatelessWidget {
  final StudentModel student;
  final int index;
  final ValueNotifier<AttendanceStatus> notifier; // ← FIX 2
  final bool disabled;

  const _AttendanceCard({
    super.key,
    required this.student,
    required this.index,
    required this.notifier,
    required this.disabled,
  });

  Color get _avatarColor {
    final colors = [
      const Color(0xFF1B5E8C),
      const Color(0xFF2E7AB5),
      const Color(0xFF3A9BD5),
      const Color(0xFF1A6B5C),
      const Color(0xFF7B4FA6),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    // ── FIX 2: Sirf ye card rebuild hoga jab is student ka notifier change ho ──
    return ValueListenableBuilder<AttendanceStatus>(
      valueListenable: notifier,
      builder: (_, status, __) {
        final isPresent = status == AttendanceStatus.present;

        return AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          margin: const EdgeInsets.only(bottom: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPresent
                  ? const Color(0xFF2ECC71).withOpacity(0.4)
                  : Colors.transparent,
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                // Avatar
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    color: _avatarColor.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(13),
                  ),
                  child: Center(
                    child: Text(
                      student.name.isNotEmpty
                          ? student.name[0].toUpperCase()
                          : '?',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: _avatarColor,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),

                // Name + Roll
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        student.name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF1A2433),
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.rollNo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF6B7A8D),
                        ),
                      ),
                    ],
                  ),
                ),

                // Status label
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: Text(
                    isPresent ? 'Present' : 'Absent',
                    key: ValueKey(isPresent),
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: isPresent
                          ? const Color(0xFF2ECC71)
                          : const Color(0xFFE74C3C),
                    ),
                  ),
                ),
                const SizedBox(width: 10),

                // Toggle Switch
                Switch(
                  value: isPresent,
                  onChanged: disabled
                      ? null
                      : (val) {
                          // ── FIX 2: Sirf is notifier ko update karo ──
                          notifier.value = val
                              ? AttendanceStatus.present
                              : AttendanceStatus.absent;
                        },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF2ECC71),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFECF0F5),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Stat Chip ────────────────────────────────────────────────────────────────

class _StatChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final Color color;

  const _StatChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: color),
          const SizedBox(width: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
