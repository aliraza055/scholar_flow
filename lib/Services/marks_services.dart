import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:scholar_flow/Models/marks_model.dart';
import 'package:scholar_flow/Services/performance_services.dart';

class MarksService {
  final _db = FirebaseFirestore.instance;

  // Singleton se same instance milega — cache wahi invalidate hoga
  final _perfService = PerformanceService();

  Future<void> saveMarks({
    required String studentId,
    required String subject,
    required double midterm,
    required double finalMarks,
  }) async {
    final total = (midterm * 0.4) + (finalMarks * 0.6);
    final grade = MarksModel.calculateGrade(total);

    final model = MarksModel(
      subject: subject,
      midterm: midterm,
      finalMarks: finalMarks,
      total: total,
      grade: grade,
    );

    final subjectId = subject.toLowerCase().replaceAll(' ', '_');

    await _db
        .collection('Students')
        .doc(studentId)
        .collection('marks')
        .doc(subjectId)
        .set(model.toMap());

    await _updateStudentGPA(studentId);
    _perfService.invalidateCache(); // ✅ Cache bust — next visit fresh data
  }

  Future<void> _updateStudentGPA(String studentId) async {
    final marksSnap = await _db
        .collection('Students')
        .doc(studentId)
        .collection('marks')
        .get();

    if (marksSnap.docs.isEmpty) return;

    double totalGPA = 0;
    for (final doc in marksSnap.docs) {
      final grade = doc.data()['grade'] ?? 'F';
      totalGPA += MarksModel.gradeToGPA(grade);
    }

    final avgGPA = totalGPA / marksSnap.docs.length;

    await _db.collection('Students').doc(studentId).update({
      'gpa': double.parse(avgGPA.toStringAsFixed(2)),
    });
  }

  Stream<QuerySnapshot> getMarksStream(String studentId) {
    return _db
        .collection('Students')
        .doc(studentId)
        .collection('marks')
        .snapshots();
  }

  Future<void> deleteMarks(String studentId, String subject) async {
    final subjectId = subject.toLowerCase().replaceAll(' ', '_');
    await _db
        .collection('Students')
        .doc(studentId)
        .collection('marks')
        .doc(subjectId)
        .delete();

    await _updateStudentGPA(studentId);
    _perfService.invalidateCache(); // ✅ Delete ke baad bhi cache bust
  }
}
