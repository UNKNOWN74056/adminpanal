import 'package:admin/admin.dart';
import 'package:admin/components/savebutton.dart';
import 'package:admin/components/textform.dart';
import 'package:admin/utils/colors/App_Colors.dart';
import 'package:admin/view/Sign_Up.dart';
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

  // Define a regular expression for a valid email
  final emailRegExp = RegExp(r'^[\w-]+(\.[\w-]+)*@([\w-]+\.)+[a-zA-Z]{2,7}$');

  // Function to check if the password meets the criteria
  bool isPasswordValid(String value) {
    // Check if the password has at least 6 characters and contains one uppercase letter
    return value.length >= 6 && value.contains(RegExp(r'[A-Z]'));
  }

  Future login() async {
    if (!emailRegExp.hasMatch(email.text)) {
      Get.snackbar(
        "Invalid Email",
        "Please enter a valid email address.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    if (!isPasswordValid(password.text)) {
      Get.snackbar(
        "Invalid Password",
        "Password should have at least 6 characters and contain one uppercase letter.",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: password.text,
      );
      Get.to(const MyAdminPage());
    } on FirebaseAuthException catch (e) {
      // Handle FirebaseAuth exceptions
      if (e.code == 'user-not-found') {
        Get.snackbar(
          "No User",
          "No user is found for this Email",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.of(context).pop();
      } else if (e.code == 'wrong-password') {
        Get.snackbar(
          "Your password",
          "Your password is wrong; please correct your password",
          backgroundColor: Colors.red,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
          snackPosition: SnackPosition.BOTTOM,
        );
        Navigator.of(context).pop();
      }
    }
  }

  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: loginFormKey,
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
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      children: [
                        reusebletextfield(
                          controller: email,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          labelText: "Enter your email",
                          validator: (value) {
                            if (!emailRegExp.hasMatch(value ?? '')) {
                              return "Invalid email";
                            }
                            return null;
                          },
                          keyboard: TextInputType.emailAddress,
                          icon: const Icon(
                            FontAwesomeIcons.solidEnvelope,
                            color: AppColors.errorColor,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        reusebletextfield(
                          controller: password,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          obscureText: true,
                          validator: (value) {
                            if (!isPasswordValid(value ?? '')) {
                              return "Invalid password";
                            }
                            return null;
                          },
                          keyboard: TextInputType.emailAddress,
                          icon: const Icon(
                            FontAwesomeIcons.lock,
                            color: AppColors.successColor,
                          ),
                          labelText: "Enter your password",
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        savebutton(
                          onTap: () {
                            if (loginFormKey.currentState!.validate()) {
                              login();
                            }
                          },
                          child: const Text("Login"),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        TextButton(
                            onPressed: () {
                              Get.to(const SignupPage());
                            },
                            child: const Text("Signup")),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
