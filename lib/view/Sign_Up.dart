import 'package:admin/components/savebutton.dart';
import 'package:admin/components/textform.dart';
import 'package:admin/utils/colors/App_Colors.dart';
import 'package:admin/view/Login_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  bool isEmailValid(String email) {
    final emailRegex =
        RegExp(r'^[\w-]+(\.[\w-]+)*@[\w-]+(\.[\w-]+)*(\.[a-z]{2,3})$');
    return emailRegex.hasMatch(email);
  }

  //signup function
  Future<void> signUp() async {
    try {
      // Sign up the user with email and password
      final UserCredential userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
              email: email.text, password: password.text);

      // Check if the user was successfully created.
      if (userCredential.user != null) {
        // Store user information in Firestore's "admin" collection.
        final userUid = userCredential.user!.uid;
        await FirebaseFirestore.instance.collection('admin').doc(userUid).set({
          'username': username.text,
          'email': email.text,
        });
      } else {
        print('Registration failed');
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        Get.snackbar(
          "Password weak",
          "Password is too weak!",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else if (e.code == 'email-already-in-use') {
        Get.snackbar(
          "Email",
          "This email is already in use. Please try a different email.",
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      } else {
        print('Error: ${e.code}');
      }
    }
  }

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Padding(
                  padding: EdgeInsets.only(right: 130, top: 30),
                  child: Text(
                    "Sign up",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                // Image at the center
                Image.asset(
                  'assets/admin.png', // Replace with your image asset path
                  width: 150, // Set the width as per your requirement
                  height: 150, // Set the height as per your requirement
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    children: [
                      reusebletextfield(
                        controller: username,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        labelText: "Enter your name",
                        icon: const Icon(
                          Icons.person,
                          color: AppColors.primaryColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      reusebletextfield(
                        controller: email,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        labelText: "Enter your eamil",
                        icon: const Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: AppColors.successColor,
                        ),
                      ),
                      const SizedBox(height: 20),
                      reusebletextfield(
                        controller: password,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        labelText: "Enter your password",
                        icon: const Icon(Icons.lock),
                      ),
                      const SizedBox(height: 20),
                      savebutton(
                          onTap: () {
                            if (isEmailValid(email.text)) {
                              signUp();
                              Get.snackbar(
                                "Message",
                                "Account created",
                                backgroundColor: Colors.green,
                                colorText: Colors.white,
                              );
                              Get.to(const Login_page());
                            } else {
                              Get.snackbar(
                                "Invalid Email",
                                "Please enter a valid email address.",
                                backgroundColor: Colors.red,
                                colorText: Colors.white,
                              );
                            }
                          },
                          child: const Text("Signup"))
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
