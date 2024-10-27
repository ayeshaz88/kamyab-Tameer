import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get_state_manager/get_state_manager.dart';
import 'package:kamiyabtameer/widgets/snackbar.dart';

class AuthController extends GetxController {

  static Future<String?> getUserTypeByEmail(String email) async {
    // Implementation to fetch user type from the backend
    // You should replace this implementation with your actual logic
    // This is just a placeholder implementation
    if (email == 'example@gmail.com') {
      return 'Client';
    } else if (email == 'example2@gmail.com') {
      return 'Contractor';
    } else if (email == 'example3@gmail.com') {
      return 'Seller';
    } else {
      return null; // Return null if the email is not found
    }
  }

  Future<String> Signup(String username, String email, String password,
      String type, BuildContext context) async {
    String err = '';
    try {
      UserCredential cred = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(email: email, password: password);

      showCustomSnackBar(EvaIcons.checkmarkCircle, "Creating Account",
          "Successfully Created", Colors.green);
      List<String> splitList = username.split(" ");
      List<String> searchIndex = [];
      searchIndex.add(username.toLowerCase());
      searchIndex.add(username.toUpperCase());
      searchIndex.add(username.replaceAll(" ", ''));
      searchIndex.add(username.split(" ").removeLast());

      for (var i = 0; i < splitList.length; i++) {
        for (var y = 0; y < splitList[i].length; y++) {
          searchIndex.add(splitList[i].substring(0, y + 1).toLowerCase());
          searchIndex.add(splitList[i].substring(0, y + 1).toUpperCase());
        }
      }
      await FirebaseFirestore.instance
          .collection('users')
          .doc(cred.user!.uid)
          .set({
        "uid": cred.user!.uid,
        "date": DateTime.now(),
        "email": email,
        "username": username,
        "password": password,
        "type": type,
        "searchIndex": searchIndex,
        "photoUrl":
        'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRhW0hzwECDKq0wfUqFADEJaNGESHQ8GRCJIg&usqp=CAU',
      });
      if (password.isEmpty && email.isEmpty) {
        err = 'fields-error';
        showCustomSnackBar(EvaIcons.alertCircle, "Error",
            "Please Fill All Fields", Colors.red);
      }
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(EvaIcons.alertCircle, "Error", e.message!, Colors.red);
      log(e.code);
      if (e.code == 'weak-password') {
        err = "password-error";

        print('The password provided is too weak.');
      } else if (e.code == 'email-already-in-use') {
        err = "email-error";
      } else if (e.code == 'invalid-email') {
        err = "invalid-email";
      } else if (e.code == 'unknown') {
        err = "fields-error";
      } else if (e.code == 'network-request-failed') {
        err = "network-error";
      } else {
        err = e.code;
      }
    } catch (e) {
      showCustomSnackBar(
          EvaIcons.alertCircle, "Error", e.toString(), Colors.red);
    }
    return err;
  }

  Future<String> loginUser(
      String email, String password, BuildContext context) async {
    String err2 = '';
    try {
      UserCredential userCredential = await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);
      print("Login done");
    } on FirebaseAuthException catch (e) {
      showCustomSnackBar(EvaIcons.alertCircle, "Error", e.message!, Colors.red);
      print(e.code);
      if (e.code == 'user-not-found') {
        err2 = 'error-user';
      } else if (e.code == 'wrong-password') {
        err2 = 'error-pass';
      } else if (e.code == 'invalid-email') {
        err2 = "invalid-email";
      } else if (e.code == 'unknown') {
        err2 = "fields-error";
      } else if (e.code == 'network-request-failed') {
        err2 = "network-error";
      } else if (e.code == 'too-many-requests') {
        err2 = "network-error";
      } else {
        err2 = e.code;
      }
    } catch (e) {
      showCustomSnackBar(
          EvaIcons.alertCircle, "Error", e.toString(), Colors.red);
    }
    return err2;
  }
}



