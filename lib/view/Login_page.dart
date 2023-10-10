import 'package:admin/admin.dart';
import 'package:admin/components/savebutton.dart';
import 'package:admin/components/textform.dart';
import 'package:admin/utils/colors/App_Colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class Login_page extends StatefulWidget {
  const Login_page({super.key});

  @override
  State<Login_page> createState() => _Login_pageState();
}

class _Login_pageState extends State<Login_page> {
  final email = TextEditingController();
  final password = TextEditingController();
  Future<void> login() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      if (e.code == 'user-not-found') {
        Get.snackbar("No User", "No user is found for this Email",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM);
        Navigator.of(context).pop();
      } else if (e.code == 'wrong-password') {
        Get.snackbar("Your password",
            "Your password is wrong; please correct your password",
            backgroundColor: Colors.red,
            colorText: Colors.white,
            duration: const Duration(seconds: 2),
            snackPosition: SnackPosition.BOTTOM);
        Navigator.of(context).pop();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const Padding(
                  padding: EdgeInsets.only(right: 180, top: 30),
                  child: Text(
                    "Login",
                    style: TextStyle(fontSize: 50),
                  ),
                ),
                Image.asset(
                  'assets/admin.png', // Replace with your image asset path
                  width: 150, // Set the width as per your requirement
                  height: 150, // Set the height as per your requirement
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    children: [
                      reusebletextfield(
                        controller: email,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        labelText: "Enter your Email",
                        icon: const Icon(
                          FontAwesomeIcons.solidEnvelope,
                          color: AppColors.black,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      reusebletextfield(
                        controller: password,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        labelText: "Enter your password",
                        icon: const Icon(
                          Icons.lock,
                          color: AppColors.successColor,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      savebutton(
                          onTap: () {
                            login();
                            Get.to(const MyAdminPage());
                          },
                          child: const Text("Login"))
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
