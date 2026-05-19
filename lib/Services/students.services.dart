import 'package:cloud_firestore/cloud_firestore.dart';

class StudentServices {
  final _studentsRef = FirebaseFirestore.instance.collection('Students');

  Stream<QuerySnapshot> getAllStudents() {
    return _studentsRef.orderBy('createdAt', descending: true).snapshots();
  }

  Future<void> deleteStudent(String studentId) async {
    await _studentsRef.doc(studentId).delete();
  }

  Future<void> updateStudent(
    String studentId,
    Map<String, dynamic> data,
  ) async {
    await _studentsRef.doc(studentId).update(data);
  }
}
