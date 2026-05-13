import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
import 'package:scholar_flow/Models/attendance_model.dart';
import 'package:scholar_flow/Models/student_model.dart';
import 'package:scholar_flow/widgets/flutter_toast.dart';

class FirebaseServices {
  Future<void> uploadStudent(
    BuildContext context, {
    required String name,
    required String rollNo,
    required String semester,
    String? teacherId,
  }) async {
    final docRef = FirebaseFirestore.instance.collection('Students').doc();
    User? user = FirebaseAuth.instance.currentUser;
    await docRef
        .set(
          StudentModel(
            id: docRef.id,
            name: name,
            rollNo: rollNo,
            semester: semester,
            teacherId: user!.uid,
          ).toMap(),
        )
        .then((value) {
          ToastError().showToast(
            message: 'uploaded student data!',
            bgColor: Colors.green,
          );
          Navigator.pushNamed(context, AppRouters.bottomNav);
        });
  }

  final _firestore = FirebaseFirestore.instance;

  Stream<List<StudentModel>> streamStudents() {
    return _firestore
        .collection('Students')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return StudentModel.fromMap(doc.data());
          }).toList();
        });
  }
  // ── Paste these two methods inside your FirebaseServices class ────────────────

  /// Ek din ki attendance submit karna
  /// [attendanceMap] = { studentId: AttendanceStatus }
  Future<void> submitAttendance({
    required Map<String, AttendanceStatus> attendanceMap,
    required List<StudentModel> students,
  }) async {
    final teacherId = FirebaseAuth.instance.currentUser!.uid;

    // Aaj ki date — time hata ke sirf date rakho
    final today = DateTime.now();
    final dateOnly = DateTime(today.year, today.month, today.day);

    // Batch write — ek baar mein sab save hoga
    final batch = FirebaseFirestore.instance.batch();

    for (final student in students) {
      final docRef = FirebaseFirestore.instance.collection('Attendance').doc();

      final record = AttendanceModel(
        id: docRef.id,
        studentId: student.id,
        studentName: student.name,
        rollNo: student.rollNo,
        teacherId: teacherId,
        status: attendanceMap[student.id] ?? AttendanceStatus.absent,
        date: dateOnly,
      );

      batch.set(docRef, record.toMap());
    }

    await batch.commit();
  }

  /// Kisi student ki attendance history lana
  Stream<List<AttendanceModel>> streamStudentAttendance(String studentId) {
    return FirebaseFirestore.instance
        .collection('Attendance')
        .where('studentId', isEqualTo: studentId)
        .orderBy('date', descending: true)
        .snapshots()
        .map(
          (snap) =>
              snap.docs.map((d) => AttendanceModel.fromMap(d.data())).toList(),
        );
  }

  /// Check — aaj ki attendance already submit ho chuki hai?
  Future<bool> isAttendanceSubmittedToday() async {
    final teacherId = FirebaseAuth.instance.currentUser!.uid;
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day);
    final end = start.add(const Duration(days: 1));

    final snap = await FirebaseFirestore.instance
        .collection('Attendance')
        .where('teacherId', isEqualTo: teacherId)
        .where('date', isGreaterThanOrEqualTo: Timestamp.fromDate(start))
        .where('date', isLessThan: Timestamp.fromDate(end))
        .limit(1)
        .get();

    return snap.docs.isNotEmpty;
  }
}
