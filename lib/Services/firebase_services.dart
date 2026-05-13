import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
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
}
