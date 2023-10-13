import 'package:admin/GETX/Total_Transection.dart';
import 'package:admin/GETX/admin._data.dart';
import 'package:admin/components/savebutton.dart';
import 'package:admin/components/shimmer_widget.dart';
import 'package:admin/components/textform.dart';
import 'package:admin/view/Login_page.dart';
import 'package:admin/widget/adminapprove.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the Firestore library

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final GlobalKey<FormState> changepasswordkey = GlobalKey<FormState>();
  final changepassword = TextEditingController();
  final oldpassword = TextEditingController();
  bool isPasswordValid(String value) {
    // Check if the password has at least 6 characters and contains one uppercase letter
    return value.length >= 6 && value.contains(RegExp(r'[A-Z]'));
  }

  Future<void> changePassword() async {
    // Fetch the current user's email
    final currentUserEmail = FirebaseAuth.instance.currentUser!.email;

    // Fetch the old password from Firestore for the current user
    DocumentSnapshot adminDoc = await FirebaseFirestore.instance
        .collection("admin")
        .doc(currentUserEmail)
        .get();

    if (adminDoc.exists) {
      // Retrieve the old password from Firestore
      String oldPasswordFromFirestore = adminDoc["password"];

      // Compare the old password from Firestore with the old password entered by the user
      if (oldPasswordFromFirestore == oldpassword.text) {
        // Old password matches, proceed to change the password
        await FirebaseFirestore.instance
            .collection("admin")
            .doc(currentUserEmail)
            .update({'password': changepassword.text});

        Get.back(); // Close the bottom sheet
        Get.snackbar("Message", "Your password is changed");
      } else {
        // Old password doesn't match
        Get.snackbar("Error", "Incorrect old password",
            backgroundColor: Colors.red, colorText: Colors.white);
      }
    }
  }

  final totalTransactionController = Get.put(TotalTransactionController());

  final adminController = Get.put(AdminController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: Drawer(
          child: ListView(
        children: <Widget>[
          Obx(() {
            if (adminController.adminDataList.isNotEmpty) {
              final adminData = adminController.adminDataList.first;
              return UserAccountsDrawerHeader(
                decoration: const BoxDecoration(
                    image: DecorationImage(
                        image: AssetImage("assets/tabletanis.jpg"))),
                accountName: Text(adminData.username,
                    style: const TextStyle(fontSize: 20)),
                accountEmail: Text(adminData.email),
              );
            } else {
              return const CircularProgressIndicator();
            }
          }),
          GestureDetector(
            onTap: () {
              showModalBottomSheet(
                  isScrollControlled: true,
                  shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(10))),
                  context: context,
                  builder: (context) => Container(
                        margin: const EdgeInsets.all(20),
                        padding: const EdgeInsets.all(8),
                        child: Padding(
                          padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom),
                          child: Form(
                            key: changepasswordkey,
                            child: SingleChildScrollView(
                              child: Column(
                                children: [
                                  const SizedBox(
                                    height: 40,
                                  ),
                                  const Text("Please enter your new password"),
                                  const SizedBox(
                                    height: 20,
                                  ),

                                  const SizedBox(
                                    height: 10,
                                  ),
                                  reusebletextfield(
                                      controller: oldpassword,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboard: TextInputType.emailAddress,
                                      validator: null,
                                      icon: const Icon(FontAwesomeIcons.lock),
                                      labelText: "Enter your old password"),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  //textfields with dailog
                                  reusebletextfield(
                                      controller: changepassword,
                                      autoValidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      keyboard: TextInputType.emailAddress,
                                      validator: (value) {
                                        if (!isPasswordValid(value ?? '')) {
                                          return "Invalid password";
                                        }
                                        return null;
                                      },
                                      icon: const Icon(FontAwesomeIcons.lock),
                                      labelText: "Enter your new password"),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  savebutton(
                                      onTap: () {
                                        if (changepasswordkey.currentState!
                                            .validate()) {
                                          Future.delayed(
                                              const Duration(seconds: 3), () {
                                            changePassword();
                                            Get.back();
                                            // Get.snackbar("Meassage",
                                            //     "Your password is changed");
                                          });
                                        }
                                      },
                                      child: const Text("Change password"))
                                ],
                              ),
                            ),
                          ),
                        ),
                      ));
            },
            child: const ListTile(
              leading: Icon(Icons.lock),
              title: Text("Change passwrod"),
            ),
          ),
          GestureDetector(
            onTap: () async {
              await FirebaseAuth.instance.signOut();
              Get.to(const Login_page());
            },
            child: const ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.green,
                ),
                title: Text("Log out")),
          ),
        ],
      )),
      appBar: AppBar(
        elevation: 20,
        centerTitle: true,
        title: const Text("Admin panel"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: GestureDetector(
              onTap: () {
                Get.to(const AdminApprovalScreen());
              },
              child: const Icon(FontAwesomeIcons.bell),
            ),
          )
        ],
      ),
      body: const ShimmerWidget(),
    );
  }
}
