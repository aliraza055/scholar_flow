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

  // studentId → present/absent — default sab absent
  final Map<String, AttendanceStatus> _attendanceMap = {};
  bool _isSubmitting = false;
  bool _alreadySubmitted = false;

  @override
  void initState() {
    super.initState();
    _checkTodaySubmission();
  }

  Future<void> _checkTodaySubmission() async {
    final done = await _service.isAttendanceSubmittedToday();
    if (mounted) setState(() => _alreadySubmitted = done);
  }

  void _initStudents(List<StudentModel> students) {
    for (final s in students) {
      _attendanceMap.putIfAbsent(s.id, () => AttendanceStatus.absent);
    }
  }

  Future<void> _submitAttendance(List<StudentModel> students) async {
    setState(() => _isSubmitting = true);
    try {
      await _service.submitAttendance(
        attendanceMap: _attendanceMap,
        students: students,
      );
      setState(() => _alreadySubmitted = true);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Attendance submitted successfully!'),
            backgroundColor: Color(0xFF2ECC71),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
        );
      }
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
            // init map when data arrives
            if (snapshot.hasData) _initStudents(snapshot.data!);

            final students = snapshot.data ?? [];
            final presentCount = _attendanceMap.values
                .where((s) => s == AttendanceStatus.present)
                .length;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ───────────────────────────────────────────────
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
                      Text(
                        "Mark today's session presence",
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFF6B7A8D),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // ── Stats Row ─────────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    children: [
                      _StatChip(
                        icon: Icons.people_rounded,
                        label: '${students.length} Enrolled',
                        color: const Color(0xFF1B5E8C),
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Icons.check_circle_outline_rounded,
                        label: '$presentCount Present',
                        color: const Color(0xFF2ECC71),
                      ),
                      const SizedBox(width: 10),
                      _StatChip(
                        icon: Icons.calendar_today_rounded,
                        label: today,
                        color: const Color(0xFF6B7A8D),
                      ),
                    ],
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
                  child: snapshot.connectionState == ConnectionState.waiting
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
                            final isPresent =
                                _attendanceMap[student.id] ==
                                AttendanceStatus.present;

                            return _AttendanceCard(
                              student: student,
                              index: index,
                              isPresent: isPresent,
                              disabled: _alreadySubmitted,
                              onToggle: (val) => setState(() {
                                _attendanceMap[student.id] = val
                                    ? AttendanceStatus.present
                                    : AttendanceStatus.absent;
                              }),
                            );
                          },
                        ),
                ),

                // ── Submit Button ─────────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 56,
                    child: ElevatedButton(
                      onPressed:
                          (_alreadySubmitted ||
                              _isSubmitting ||
                              students.isEmpty)
                          ? null
                          : () => _submitAttendance(students),
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
                                  : 'Submit Attendance  ($presentCount/${students.length})',
                              style: const TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                    ),
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

// ─── Attendance Card ──────────────────────────────────────────────────────────

class _AttendanceCard extends StatelessWidget {
  final StudentModel student;
  final int index;
  final bool isPresent;
  final bool disabled;
  final ValueChanged<bool> onToggle;

  const _AttendanceCard({
    required this.student,
    required this.index,
    required this.isPresent,
    required this.disabled,
    required this.onToggle,
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
                  student.name.isNotEmpty ? student.name[0].toUpperCase() : '?',
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
              onChanged: disabled ? null : onToggle,
              activeColor: Colors.white,
              activeTrackColor: const Color(0xFF2ECC71),
              inactiveThumbColor: Colors.white,
              inactiveTrackColor: const Color(0xFFECF0F5),
            ),
          ],
        ),
      ),
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
} // import 'package:flutter/material.dart';
// import 'package:scholar_flow/Models/student_model.dart';
// import 'package:scholar_flow/Services/firebase_services.dart';
// import 'package:scholar_flow/widgets/app_bar.dart';
// import 'package:scholar_flow/widgets/flutter_toast.dart';

// class AttendanceScreen extends StatefulWidget {
//   @override
//   _AttendanceScreenState createState() => _AttendanceScreenState();
// }

// class _AttendanceScreenState extends State<AttendanceScreen> {
//   final FirebaseServices _service = FirebaseServices();

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       extendBody: true,
//       appBar: CustomAppBar(),
//       backgroundColor: Color(0xfff4f6f8),
//       body: Padding(
//         padding: const EdgeInsets.symmetric(horizontal: 16),
//         child: Column(
//           children: [
//             /// Top Bar
//             /// Title
//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Class Attendance",
//                 style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
//               ),
//             ),

//             Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Mark the presence for today's session",
//                 style: TextStyle(color: Colors.grey),
//               ),
//             ),

//             SizedBox(height: 20),

//             /// Dropdown
//             Container(
//               padding: EdgeInsets.symmetric(horizontal: 16),
//               height: 60,
//               decoration: BoxDecoration(
//                 color: Colors.white,
//                 borderRadius: BorderRadius.circular(15),
//               ),
//               child: Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: [
//                   Text("Software Quality Assurance"),
//                   Icon(Icons.keyboard_arrow_down),
//                 ],
//               ),
//             ),

//             SizedBox(height: 15),

//             /// Info Row
//             Row(
//               children: [
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF006692),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     "3 ENROLLED",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Container(
//                   padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//                   decoration: BoxDecoration(
//                     color: Color(0xFF006692),
//                     borderRadius: BorderRadius.circular(20),
//                   ),
//                   child: Text(
//                     "April 24, 2026",
//                     style: TextStyle(color: Colors.white),
//                   ),
//                 ),
//               ],
//             ),

//             SizedBox(height: 20),

//             /// Student List
//             Expanded(
//               child: StreamBuilder<List<StudentModel>>(
//                 stream: _service.streamStudents(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return Center(child: CircularProgressIndicator());
//                   }
//                   if (snapshot.hasError) {
//                     ToastError().showToast(
//                       message: 'Something went wrong',
//                       bgColor: Colors.red,
//                     );
//                   }
//                   if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     ToastError().showToast(
//                       message: 'Something went wrong',
//                       bgColor: Colors.red,
//                     );
//                   }
//                   final students = snapshot.data!;

//                   return ListView.builder(
//                     itemCount: students.length,
//                     itemBuilder: (context, index) {
//                       return Container(
//                         margin: EdgeInsets.only(bottom: 12),
//                         padding: EdgeInsets.all(12),
//                         decoration: BoxDecoration(
//                           color: Colors.white,
//                           borderRadius: BorderRadius.circular(15),
//                         ),
//                         child: Row(
//                           children: [
//                             CircleAvatar(
//                               backgroundColor: Colors.grey.shade300,
//                               child: Icon(
//                                 Icons.person,
//                                 color: Color(0xFF006692),
//                               ),
//                             ),
//                             SizedBox(width: 12),

//                             /// Name + ID
//                             Expanded(
//                               child: Column(
//                                 crossAxisAlignment: CrossAxisAlignment.start,
//                                 children: [
//                                   Text(
//                                     students[index].name,
//                                     style: TextStyle(
//                                       fontWeight: FontWeight.bold,
//                                     ),
//                                   ),
//                                   Text(
//                                     students[index].rollNo,
//                                     style: TextStyle(color: Colors.grey),
//                                   ),
//                                 ],
//                               ),
//                             ),

//                             /// Switch
//                             // Switch(
//                             //   value: student["present"],
//                             //   activeColor: Colors.white, // button (thumb)
//                             //   activeTrackColor: Color(
//                             //     0xFF006692,
//                             //   ), // ON background
//                             //   onChanged: (val) {
//                             //     setState(() {
//                             //       student["present"] = val;
//                             //     });
//                             //   },
//                             // ),
//                           ],
//                         ),
//                       );
//                     },
//                   );
//                 },
//               ),
//             ),

//             /// Submit Button
//             Container(
//               width: double.infinity,
//               height: 55,
//               margin: EdgeInsets.only(bottom: 100),
//               child: ElevatedButton(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xff0d5c7d),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 onPressed: () {},
//                 child: Text(
//                   "Submit Attendance",
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.white,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
