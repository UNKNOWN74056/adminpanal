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
      Future.delayed(const Duration(seconds: 2), () {
        Get.to(const MyAdminPage());
      });
    } else {
      Timer(const Duration(seconds: 2), () => Get.to(const Login_page()));
    }
  }
}
