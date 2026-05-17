import 'package:cloud_firestore/cloud_firestore.dart';

class StudentServices {
  final _studentsRef = FirebaseFirestore.instance.collection('Students');

  /// Fetch all students (admin view)
  Stream<QuerySnapshot> getAllStudents() {
    return _studentsRef.orderBy('createdAt', descending: true).snapshots();
  }

  /// Delete student
  Future<void> deleteStudent(String studentId) async {
    await _studentsRef.doc(studentId).delete();
  }

  /// Update student
  Future<void> updateStudent(
    String studentId,
    Map<String, dynamic> data,
  ) async {
    await _studentsRef.doc(studentId).update(data);
  }
}
