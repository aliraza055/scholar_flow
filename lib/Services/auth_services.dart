import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:scholar_flow/Models/admin_model.dart';

class Auth {
  Future<void> signIN(String name, String gmail, String password) async {
    UserCredential credential = await FirebaseAuth.instance
        .createUserWithEmailAndPassword(email: gmail, password: password);
    User user = credential.user!;
    user.updateDisplayName(name);
    user.reload();
    await FirebaseFirestore.instance
        .collection('Teachers')
        .doc(user.uid)
        .set(
          TeacherModel(
            id: user.uid,
            name: name,
            gmail: gmail,
            image: 'image',
            subject: 'subject',
          ).toMap(),
        );
  }
}
