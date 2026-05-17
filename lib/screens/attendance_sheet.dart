import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart' show DateFormat;
import 'package:scholar_flow/Models/attendance_model.dart';
import 'package:scholar_flow/Models/student_model.dart';
import 'package:scholar_flow/Services/firebase_services.dart';
import 'package:scholar_flow/widgets/flutter_toast.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FirebaseServices _service = FirebaseServices();

  final Map<String, ValueNotifier<AttendanceStatus>> _notifiers = {};
  bool _isSubmitting = false;
  bool _alreadySubmitted = false;
  bool _studentsInitialized = false;
  List<StudentModel> _students = [];
  final ValueNotifier<int> _presentCount = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    _checkTodaySubmission();
  }

  @override
  void dispose() {
    for (final n in _notifiers.values) n.dispose();
    _presentCount.dispose();
    super.dispose();
  }

  Future<void> _checkTodaySubmission() async {
    final done = await _service.isAttendanceSubmittedToday();
    if (mounted) setState(() => _alreadySubmitted = done);
  }

  void _initStudentsOnce(List<StudentModel> incoming) {
    if (_studentsInitialized) return;
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
    final attendanceMap = {
      for (final entry in _notifiers.entries) entry.key: entry.value.value,
    };
    try {
      await _service.submitAttendance(attendanceMap: attendanceMap);
      setState(() {
        _alreadySubmitted = true;
        _isSubmitting = false;
      });
      if (mounted) {
        ToastError().showToast(
          message: 'Attendance submitted successfully!',
          bgColor: Colors.green,
        );
      }
    } catch (e) {
      setState(() => _isSubmitting = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceAll('Exception: ', '')),
            backgroundColor: const Color(0xFFEF4444),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    final today = DateFormat('MMMM dd, yyyy').format(DateTime.now());

    // ── How much bottom space the floating nav bar takes ──────────────────
    // nav margin-bottom(20) + vertical-padding(10+10) + item-height(~40) = ~80
    // + device safe-area bottom padding
    final double navBarOffset = 80.0 + MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FA),
      body: StreamBuilder<List<StudentModel>>(
        stream: _service.streamStudents(),
        builder: (context, snapshot) {
          if (snapshot.hasData) _initStudentsOnce(snapshot.data!);
          final students = _students;

          return Column(
            children: [
              // ── Header ────────────────────────────────────────────────
              _buildHeader(today, students.length),
              const SizedBox(height: 16),

              // ── Already submitted banner ──────────────────────────────
              if (_alreadySubmitted)
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 10, 20, 12),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B870).withOpacity(0.08),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: const Color(0xFF14B870).withOpacity(0.3),
                      ),
                    ),
                    child: const Row(
                      children: [
                        Icon(
                          Icons.check_circle_rounded,
                          color: Color(0xFF14B870),
                          size: 17,
                        ),
                        SizedBox(width: 9),
                        Text(
                          "Today's attendance already submitted",
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Color(0xFF0D7A4A),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              // ── Student List ──────────────────────────────────────────
              Expanded(
                child:
                    snapshot.connectionState == ConnectionState.waiting &&
                        !_studentsInitialized
                    ? const Center(
                        child: CircularProgressIndicator(
                          color: Color(0xFF1A73E8),
                          strokeWidth: 2.5,
                        ),
                      )
                    : students.isEmpty
                    ? _buildEmptyState()
                    : ListView.builder(
                        // ✅ FIX: bottom padding keeps last card above
                        // the submit button which itself sits above nav bar
                        padding: EdgeInsets.fromLTRB(
                          20,
                          4,
                          20,
                          navBarOffset + 70,
                        ),
                        physics: const BouncingScrollPhysics(),
                        itemCount: students.length,
                        itemBuilder: (context, index) {
                          final student = students[index];
                          final notifier = _notifiers[student.id]!;
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
              _buildSubmitButton(students, navBarOffset),
            ],
          );
        },
      ),
    );
  }

  // ── Header ────────────────────────────────────────────────────────────────

  Widget _buildHeader(String today, int totalStudents) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 32, 20, 28),
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
          Positioned(
            right: -18,
            top: -18,
            child: Container(
              width: 110,
              height: 110,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.06),
              ),
            ),
          ),
          Positioned(
            right: 40,
            bottom: -30,
            child: Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.04),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.white.withOpacity(0.15)),
                    ),
                    child: const Icon(
                      Icons.fact_check_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: Colors.white.withOpacity(0.2)),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          size: 11,
                          color: Colors.white.withOpacity(0.8),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          today,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Class Attendance',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 5),
              Text(
                "Mark today's session presence for all students.",
                style: TextStyle(
                  color: Colors.white.withOpacity(0.6),
                  fontSize: 13,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 18),
              ValueListenableBuilder<int>(
                valueListenable: _presentCount,
                builder: (_, count, __) {
                  final absent = totalStudents - count;
                  return Row(
                    children: [
                      _HeaderStat(
                        label: 'Total',
                        value: '$totalStudents',
                        icon: Icons.people_rounded,
                      ),
                      const SizedBox(width: 10),
                      _HeaderStat(
                        label: 'Present',
                        value: '$count',
                        icon: Icons.check_circle_outline_rounded,
                        valueColor: const Color(0xFF4ADE80),
                      ),
                      const SizedBox(width: 10),
                      _HeaderStat(
                        label: 'Absent',
                        value: '$absent',
                        icon: Icons.cancel_outlined,
                        valueColor: const Color(0xFFF87171),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ── Submit Button ─────────────────────────────────────────────────────────
  // ✅ FIX: bottom padding = navBarOffset so button sits just above the nav bar

  Widget _buildSubmitButton(List<StudentModel> students, double navBarOffset) {
    return ValueListenableBuilder<int>(
      valueListenable: _presentCount,
      builder: (_, count, __) {
        final isDisabled =
            _alreadySubmitted || _isSubmitting || students.isEmpty;

        return Padding(
          padding: EdgeInsets.fromLTRB(20, 8, 20, navBarOffset + 8),
          child: SizedBox(
            width: double.infinity,
            height: 54,
            child: ElevatedButton(
              onPressed: isDisabled ? null : _submitAttendance,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1A3A6E),
                disabledBackgroundColor: const Color(
                  0xFF1A3A6E,
                ).withOpacity(0.35),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        color: Colors.white,
                      ),
                    )
                  : Text(
                      _alreadySubmitted
                          ? '✓  Already Submitted'
                          : 'Submit Attendance  ($count / ${students.length})',
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                      ),
                    ),
            ),
          ),
        );
      },
    );
  }

  // ── Empty State ───────────────────────────────────────────────────────────

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: const Color(0xFF1A73E8).withOpacity(0.08),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: const Color(0xFF1A73E8).withOpacity(0.15),
              ),
            ),
            child: const Icon(
              Icons.person_off_rounded,
              size: 36,
              color: Color(0xFF1A73E8),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'No students found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Add students to mark attendance.',
            style: TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
        ],
      ),
    );
  }
}

// ── Header Stat ───────────────────────────────────────────────────────────────

class _HeaderStat extends StatelessWidget {
  final String label;
  final String value;
  final IconData icon;
  final Color? valueColor;

  const _HeaderStat({
    required this.label,
    required this.value,
    required this.icon,
    this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.10),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.white.withOpacity(0.12)),
        ),
        child: Row(
          children: [
            Icon(icon, size: 14, color: Colors.white.withOpacity(0.7)),
            const SizedBox(width: 7),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: valueColor ?? Colors.white,
                    height: 1,
                  ),
                ),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 10,
                    color: Colors.white.withOpacity(0.55),
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Attendance Card ───────────────────────────────────────────────────────────

class _AttendanceCard extends StatelessWidget {
  final StudentModel student;
  final int index;
  final ValueNotifier<AttendanceStatus> notifier;
  final bool disabled;

  const _AttendanceCard({
    super.key,
    required this.student,
    required this.index,
    required this.notifier,
    required this.disabled,
  });

  Color get _avatarColor {
    const colors = [
      Color(0xFF3B7DD8),
      Color(0xFF7C5CBF),
      Color(0xFF0F9E7B),
      Color(0xFFD4522A),
      Color(0xFF1A8FA8),
    ];
    return colors[index % colors.length];
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<AttendanceStatus>(
      valueListenable: notifier,
      builder: (_, status, __) {
        final isPresent = status == AttendanceStatus.present;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: isPresent
                  ? const Color(0xFF14B870).withOpacity(0.35)
                  : const Color(0xFFE8ECF4),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 10,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  width: 46,
                  height: 46,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [_avatarColor, _avatarColor.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Center(
                    child: Text(
                      student.name.isNotEmpty
                          ? student.name[0].toUpperCase()
                          : '?',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
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
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        student.rollNo,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF94A3B8),
                          fontWeight: FontWeight.w500,
                        ),
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
                    color: isPresent
                        ? const Color(0xFF14B870).withOpacity(0.10)
                        : const Color(0xFFEF4444).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    isPresent ? 'Present' : 'Absent',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: isPresent
                          ? const Color(0xFF14B870)
                          : const Color(0xFFEF4444),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Switch(
                  value: isPresent,
                  onChanged: disabled
                      ? null
                      : (val) {
                          notifier.value = val
                              ? AttendanceStatus.present
                              : AttendanceStatus.absent;
                        },
                  activeColor: Colors.white,
                  activeTrackColor: const Color(0xFF14B870),
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: const Color(0xFFE2E8F0),
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
