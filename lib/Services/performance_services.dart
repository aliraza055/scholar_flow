import 'package:cloud_firestore/cloud_firestore.dart';

class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  final _db = FirebaseFirestore.instance;

  Future<BatchStats>? _cachedBatchStats;
  Future<List<SubjectProficiency>>? _cachedProficiency;
  Future<List<AtRiskStudent>>? _cachedAtRisk;
  Future<AttendanceStats>? _cachedAttendance;

  void invalidateCache() {
    _cachedBatchStats = null;
    _cachedProficiency = null;
    _cachedAtRisk = null;
    _cachedAttendance = null;
  }

  Future<BatchStats> getBatchStats() =>
      _cachedBatchStats ??= _fetchBatchStats();

  Future<List<SubjectProficiency>> getSubjectProficiency() =>
      _cachedProficiency ??= _fetchSubjectProficiency();

  Future<List<AtRiskStudent>> getAtRiskStudents() =>
      _cachedAtRisk ??= _fetchAtRiskStudents();

  Future<AttendanceStats> getAttendanceStats() =>
      _cachedAttendance ??= _fetchAttendanceStats();

  Future<BatchStats> _fetchBatchStats() async {
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
        final pct = (markDoc.data()['total'] ?? 0).toDouble();
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

  Future<AttendanceStats> _fetchAttendanceStats() async {
    final attendanceSnap = await _db.collection('Attendance').get();

    if (attendanceSnap.docs.isEmpty)
      return AttendanceStats(averagePercentage: 0.0);

    int totalPresent = 0;
    int totalRecords = 0;

    for (final doc in attendanceSnap.docs) {
      final records = (doc.data()['records'] as Map<String, dynamic>?) ?? {};
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

  Future<List<SubjectProficiency>> _fetchSubjectProficiency() async {
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

  Future<List<AtRiskStudent>> _fetchAtRiskStudents() async {
    final studentsSnap = await _db.collection('Students').get();
    final List<AtRiskStudent> atRisk = [];

    for (final doc in studentsSnap.docs) {
      final name = (doc.data()['name'] ?? 'Unknown') as String;

      final marksSnap = await _db
          .collection('Students')
          .doc(doc.id)
          .collection('marks')
          .get();

      if (marksSnap.docs.isEmpty) continue;

      double totalPct = 0;
      int count = 0;
      for (final markDoc in marksSnap.docs) {
        totalPct += (markDoc.data()['total'] ?? 0).toDouble();
        count++;
      }

      if (count == 0) continue;
      final percentage = totalPct / count;

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

// ── Models ─────────────────────────────────────────────────────────────────────

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
