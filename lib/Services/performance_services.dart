// import 'package:cloud_firestore/cloud_firestore.dart';

// class PerformanceService {
//   final _db = FirebaseFirestore.instance;

//   // ── Batch Summary Stats ──────────────────────────────────────────────────
//   // Marks subcollection se calculate karta hai (obtained/total fields)
//   Future<BatchStats> getBatchStats() async {
//     final studentsSnap = await _db.collection('Students').get();

//     if (studentsSnap.docs.isEmpty) {
//       return BatchStats(
//         totalStudents: 0,
//         averageGPA: 0,
//         topScore: 0,
//         passRate: 0,
//       );
//     }

//     final totalStudents = studentsSnap.docs.length;
//     double totalPercentage = 0;
//     double topScore = 0;
//     int passCount = 0;
//     int studentsWithMarks = 0;

//     for (final studentDoc in studentsSnap.docs) {
//       // Marks subcollection se fetch karo
//       final marksSnap = await _db
//           .collection('Students')
//           .doc(studentDoc.id)
//           .collection('marks')
//           .get();

//       if (marksSnap.docs.isEmpty) continue;

//       // Is student ka overall percentage nikalo
//       double studentObtained = 0;
//       double studentTotal = 0;

//       for (final markDoc in marksSnap.docs) {
//         final data = markDoc.data();
//         // Support karta hai: obtained+total ya score+maxScore ya marks+totalMarks
//         final obtained =
//             (data['obtained'] ?? data['score'] ?? data['marks'] ?? 0)
//                 .toDouble();
//         final total =
//             (data['total'] ?? data['maxScore'] ?? data['totalMarks'] ?? 100)
//                 .toDouble();

//         studentObtained += obtained;
//         studentTotal += total;
//       }

//       if (studentTotal == 0) continue;

//       final studentPercentage = (studentObtained / studentTotal) * 100;
//       studentsWithMarks++;
//       totalPercentage += studentPercentage;

//       if (studentPercentage > topScore) topScore = studentPercentage;

//       // Pass = 50% se upar
//       if (studentPercentage >= 50) passCount++;
//     }

//     final averagePercentage = studentsWithMarks > 0
//         ? totalPercentage / studentsWithMarks
//         : 0.0;
//     final passRate = studentsWithMarks > 0
//         ? (passCount / studentsWithMarks) * 100
//         : 0.0;

//     return BatchStats(
//       totalStudents: totalStudents,
//       averageGPA: double.parse(averagePercentage.toStringAsFixed(1)),
//       topScore: double.parse(topScore.toStringAsFixed(1)),
//       passRate: double.parse(passRate.toStringAsFixed(1)),
//     );
//   }

//   // ── Subject Proficiency ──────────────────────────────────────────────────
//   Future<List<SubjectProficiency>> getSubjectProficiency() async {
//     final studentsSnap = await _db.collection('Students').get();
//     final Map<String, List<double>> subjectTotals = {};

//     for (final studentDoc in studentsSnap.docs) {
//       final marksSnap = await _db
//           .collection('Students')
//           .doc(studentDoc.id)
//           .collection('marks')
//           .get();

//       for (final markDoc in marksSnap.docs) {
//         final data = markDoc.data();
//         final subject = data['subject'] as String? ?? '';
//         final obtained =
//             (data['obtained'] ?? data['score'] ?? data['marks'] ?? 0)
//                 .toDouble();
//         final total =
//             (data['total'] ?? data['maxScore'] ?? data['totalMarks'] ?? 100)
//                 .toDouble();

//         if (subject.isNotEmpty && total > 0) {
//           final percentage = (obtained / total) * 100;
//           subjectTotals.putIfAbsent(subject, () => []);
//           subjectTotals[subject]!.add(percentage);
//         }
//       }
//     }

//     if (subjectTotals.isEmpty) return [];

//     return subjectTotals.entries.map((entry) {
//       final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
//       return SubjectProficiency(
//         subject: entry.key,
//         average: double.parse(avg.toStringAsFixed(1)),
//       );
//     }).toList()..sort((a, b) => b.average.compareTo(a.average));
//   }

//   // ── At Risk Students ─────────────────────────────────────────────────────
//   // Marks subcollection se percentage calculate karke at-risk decide karta hai
//   Future<List<AtRiskStudent>> getAtRiskStudents() async {
//     final studentsSnap = await _db.collection('Students').get();
//     final List<AtRiskStudent> atRisk = [];

//     for (final doc in studentsSnap.docs) {
//       final data = doc.data();
//       final name = (data['name'] ?? 'Unknown') as String;

//       final marksSnap = await _db
//           .collection('Students')
//           .doc(doc.id)
//           .collection('marks')
//           .get();

//       if (marksSnap.docs.isEmpty) continue;

//       double obtained = 0;
//       double total = 0;

//       for (final markDoc in marksSnap.docs) {
//         final mData = markDoc.data();
//         obtained += (mData['obtained'] ?? mData['score'] ?? mData['marks'] ?? 0)
//             .toDouble();
//         total +=
//             (mData['total'] ?? mData['maxScore'] ?? mData['totalMarks'] ?? 100)
//                 .toDouble();
//       }

//       if (total == 0) continue;

//       final percentage = (obtained / total) * 100;

//       // 50% se kam = at risk
//       if (percentage < 50) {
//         atRisk.add(
//           AtRiskStudent(
//             name: name,
//             reason:
//                 'Overall score: ${percentage.toStringAsFixed(1)}% (Below passing)',
//           ),
//         );
//       }
//     }

//     return atRisk;
//   }

//   // ── Attendance Stats ─────────────────────────────────────────────────────
//   // Attendance alag collection se fetch karta hai
//   Future<AttendanceStats> getAttendanceStats() async {
//     final attendanceSnap = await _db.collection('Attendance').get();

//     if (attendanceSnap.docs.isEmpty) {
//       return AttendanceStats(averagePercentage: 0, trend: 0);
//     }

//     double totalPresent = 0;
//     double totalDays = 0;

//     for (final doc in attendanceSnap.docs) {
//       final data = doc.data();
//       totalPresent += (data['present'] ?? data['presentDays'] ?? 0).toDouble();
//       totalDays += (data['total'] ?? data['totalDays'] ?? 0).toDouble();
//     }

//     final avg = totalDays > 0 ? (totalPresent / totalDays) * 100 : 0.0;

//     return AttendanceStats(
//       averagePercentage: double.parse(avg.toStringAsFixed(1)),
//       trend: -2.4, // Agar trend Firestore mein store ho toh wahan se lo
//     );
//   }
// }

// // ── Data Models ──────────────────────────────────────────────────────────────

// class BatchStats {
//   final int totalStudents;
//   final double averageGPA; // Actually average percentage hai
//   final double topScore;
//   final double passRate;

//   BatchStats({
//     required this.totalStudents,
//     required this.averageGPA,
//     required this.topScore,
//     required this.passRate,
//   });
// }

// class SubjectProficiency {
//   final String subject;
//   final double average; // Percentage out of 100

//   SubjectProficiency({required this.subject, required this.average});
// }

// class AtRiskStudent {
//   final String name;
//   final String reason;

//   AtRiskStudent({required this.name, required this.reason});
// }

// class AttendanceStats {
//   final double averagePercentage;
//   final double trend; // Positive = upar, Negative = neeche

//   AttendanceStats({required this.averagePercentage, required this.trend});
// }
import 'package:cloud_firestore/cloud_firestore.dart';

class PerformanceService {
  final _db = FirebaseFirestore.instance;

  // ── Batch Summary Stats ──────────────────────────────────────────────────
  // Sirf yeh function replace karo performance_services.dart mein

  Future<BatchStats> getBatchStats() async {
    final studentsSnap = await _db.collection('Students').get();

    if (studentsSnap.docs.isEmpty) {
      return BatchStats(
        totalStudents: 0,
        averageGPA: 0,
        topScore: 0,
        passRate: 0,
      );
    }

    final totalStudents = studentsSnap.docs.length;
    double totalPercentage = 0;
    double topScore = 0;
    int passCount = 0;
    int studentsWithMarks = 0;

    for (final studentDoc in studentsSnap.docs) {
      final marksSnap = await _db
          .collection('Students')
          .doc(studentDoc.id)
          .collection('marks')
          .get();

      if (marksSnap.docs.isEmpty) continue;

      double studentTotalPct = 0;
      int subjectCount = 0;

      for (final markDoc in marksSnap.docs) {
        final data = markDoc.data();
        // ✅ 'total' field use karo — yeh already weighted % hai (MarksModel se)
        final pct = (data['total'] ?? 0).toDouble();
        studentTotalPct += pct;
        subjectCount++;
      }

      if (subjectCount == 0) continue;

      final avgPct = studentTotalPct / subjectCount;
      studentsWithMarks++;
      totalPercentage += avgPct;
      if (avgPct > topScore) topScore = avgPct;
      if (avgPct >= 50) passCount++;
    }

    final avg = studentsWithMarks > 0
        ? totalPercentage / studentsWithMarks
        : 0.0;
    final passRate = studentsWithMarks > 0
        ? (passCount / studentsWithMarks) * 100
        : 0.0;

    return BatchStats(
      totalStudents: totalStudents,
      averageGPA: double.parse(avg.toStringAsFixed(1)),
      topScore: double.parse(topScore.toStringAsFixed(1)),
      passRate: double.parse(passRate.toStringAsFixed(1)),
    );
  }
  // ── performance_services.dart mein yeh method add karo ──────────────────────

  Future<AttendanceStats> getAttendanceStats() async {
    final attendanceSnap = await _db.collection('Attendance').get();

    if (attendanceSnap.docs.isEmpty) {
      return AttendanceStats(averagePercentage: 0.0);
    }

    int totalPresent = 0;
    int totalRecords = 0;

    for (final doc in attendanceSnap.docs) {
      final data = doc.data();

      // records ek Map hai: { "studentId": "present"/"absent" }
      final records = data['records'] as Map<String, dynamic>? ?? {};

      for (final status in records.values) {
        totalRecords++;
        if (status == 'present') totalPresent++;
      }
    }

    final avg = totalRecords > 0 ? (totalPresent / totalRecords) * 100 : 0.0;

    return AttendanceStats(
      averagePercentage: double.parse(avg.toStringAsFixed(1)),
    );
  }

  // ── Model bhi add karo file ke neeche ────────────────────────────────────────

  // ── Subject Proficiency ──────────────────────────────────────────────────
  Future<List<SubjectProficiency>> getSubjectProficiency() async {
    final studentsSnap = await _db.collection('Students').get();

    final Map<String, List<double>> subjectTotals = {};

    for (final studentDoc in studentsSnap.docs) {
      final marksSnap = await _db
          .collection('Students')
          .doc(studentDoc.id)
          .collection('marks')
          .get();

      for (final markDoc in marksSnap.docs) {
        final data = markDoc.data();
        final subject = data['subject'] as String? ?? '';
        final total = (data['total'] ?? 0).toDouble();

        if (subject.isNotEmpty) {
          subjectTotals.putIfAbsent(subject, () => []);
          subjectTotals[subject]!.add(total);
        }
      }
    }

    if (subjectTotals.isEmpty) return [];

    return subjectTotals.entries.map((entry) {
      final avg = entry.value.reduce((a, b) => a + b) / entry.value.length;
      return SubjectProficiency(
        subject: entry.key,
        average: double.parse(avg.toStringAsFixed(1)),
      );
    }).toList()..sort((a, b) => b.average.compareTo(a.average));
  }

  // ── At Risk Students ─────────────────────────────────────────────────────
  Future<List<AtRiskStudent>> getAtRiskStudents() async {
    final studentsSnap = await _db.collection('Students').get();
    final List<AtRiskStudent> atRisk = [];

    for (final doc in studentsSnap.docs) {
      final data = doc.data();
      final name = (data['name'] ?? 'Unknown') as String;

      final marksSnap = await _db
          .collection('Students')
          .doc(doc.id)
          .collection('marks')
          .get();

      if (marksSnap.docs.isEmpty) continue;

      double obtained = 0;
      double total = 0;

      for (final markDoc in marksSnap.docs) {
        final mData = markDoc.data();
        obtained += (mData['obtained'] ?? mData['score'] ?? mData['marks'] ?? 0)
            .toDouble();
        total +=
            (mData['total'] ?? mData['maxScore'] ?? mData['totalMarks'] ?? 100)
                .toDouble();
      }

      if (total == 0) continue;

      final percentage = (obtained / total) * 100;

      // 50% se kam = at risk
      if (percentage < 50) {
        atRisk.add(
          AtRiskStudent(
            name: name,
            reason:
                'Overall score: ${percentage.toStringAsFixed(1)}% (Below passing)',
          ),
        );
      }
    }

    return atRisk;
  }
}

// ── Data Models ──────────────────────────────────────────────────────────────
class AttendanceStats {
  final double averagePercentage;
  AttendanceStats({required this.averagePercentage});
}

class BatchStats {
  final int totalStudents;
  final double averageGPA;
  final double topScore;
  final double passRate;

  BatchStats({
    required this.totalStudents,
    required this.averageGPA,
    required this.topScore,
    required this.passRate,
  });
}

class SubjectProficiency {
  final String subject;
  final double average;

  SubjectProficiency({required this.subject, required this.average});
}

class AtRiskStudent {
  final String name;
  final String reason;

  AtRiskStudent({required this.name, required this.reason});
}
