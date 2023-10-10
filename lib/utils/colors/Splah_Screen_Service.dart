import 'dart:async';
import 'package:admin/admin.dart';
import 'package:admin/view/Login_page.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class splashservice {
  void islogin(BuildContext context) {
    final auth = FirebaseAuth.instance;
    final user = auth.currentUser;
    if (user != null) {
      loginischeck();
    } else {
      Timer(
          const Duration(seconds: 2),
          () => Navigator.push(context,
              MaterialPageRoute(builder: ((context) => const MyAdminPage()))));
    }
  }

  loginischeck() {
    final currentuser = FirebaseAuth.instance.currentUser!.email;
    final user = currentuser;
    if (user == null) {
      // User is not logged in, navigate to the login screen
      Get.to(const Login_page());
      return;
    }
  }
}
