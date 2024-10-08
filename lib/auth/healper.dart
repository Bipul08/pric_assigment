import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


class AuthHelper {
  Future<void> signUp(String email, String password) async {
    try {
      await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      Fluttertoast.showToast(msg: "Success signup");
      print("///////// Success ////////");
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'weak-password') {
        message = 'The password provided is too weak.';
      } else if (e.code == 'email-already-in-use') {
        message = 'The account already exists for that email.';
      } else {
        message = e.message ?? 'An error occurred. Please try again.';
      }
      Fluttertoast.showToast(msg: message);
      print(message);
    }
  }

  Future<void> login(BuildContext context, String email, String password) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      Fluttertoast.showToast(msg: "Success login");
      print("///////// Success ////////");

      // Navigate to the Image List screen after login
      // Navigator.pushReplacement(
      //   context,
      //   MaterialPageRoute(
      //     // builder: (context) => ImageListScreen(imageModel: ImageModel(results: [])), // You might want to change this if you have some initial data to show
      //   ),
      // );
    } on FirebaseAuthException catch (e) {
      String message;
      if (e.code == 'user-not-found') {
        message = 'No user found for that email.';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user.';
      } else {
        message = e.message ?? 'An error occurred. Please try again.';
      }
      Fluttertoast.showToast(msg: message);
      print(message);
    }
  }
}
