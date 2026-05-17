import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:scholar_flow/Core/Routers/app_routers.dart';
import 'package:scholar_flow/Models/admin_model.dart';
import 'package:scholar_flow/widgets/flutter_toast.dart';

class Auth {
  Future<void> signUp(
    BuildContext context,
    String name,
    String gmail,
    String password,
    String subject,
  ) async {
    try {
      UserCredential credential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: gmail.trim(),
            password: password.trim(),
          );
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
              subject: subject,
            ).toMap(),
          )
          .then((value) {
            Navigator.pushReplacementNamed(context, AppRouters.bottomNav);
            ToastError().showToast(
              message: 'Account created successfully! ',
              bgColor: Colors.green,
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ToastError().showToast(
          message: "Your password is weak!",
          bgColor: Colors.red,
        );
      } else if (e.code == 'email-already-in-use') {
        ToastError().showToast(
          message: "This email is already used!",
          bgColor: Colors.red,
        );
      } else {
        ToastError().showToast(
          message: 'Error:${e.message}',
          bgColor: Colors.red,
        );
      }
    } catch (e) {
      ToastError().showToast(
        message: 'An unexpected error',
        bgColor: Colors.red,
      );
    }
  }

  Future<void> signIn(
    BuildContext context,
    String gmail,
    String password,
  ) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: gmail.trim(),
            password: password.trim(),
          )
          .then((value) {
            Navigator.pushReplacementNamed(context, AppRouters.bottomNav);
            ToastError().showToast(
              message: 'login Sucessful!',
              bgColor: Colors.green,
            );
          });
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found') {
        ToastError().showToast(message: 'User not found!', bgColor: Colors.red);
      } else if (e.code == 'wrong-password') {
        ToastError().showToast(
          message: 'incorrect password',
          bgColor: Colors.red,
        );
      } else {
        ToastError().showToast(
          message: 'Error:${e.message}',
          bgColor: Colors.red,
        );
      }
    } catch (e) {
      ToastError().showToast(message: 'Unexpected error', bgColor: Colors.red);
    }
  }
}
