import 'package:admin/GETX/Total_Tournmaent.dart';
import 'package:admin/GETX/Total_Tournmaents.dart';
import 'package:admin/GETX/Total_Transection.dart';
import 'package:admin/GETX/admin._data.dart';
import 'package:admin/components/savebutton.dart';
import 'package:admin/components/textform.dart';
import 'package:admin/utils/colors/App_Colors.dart';
import 'package:admin/user/Show_User.dart';
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
  bool isPasswordValid(String value) {
    // Check if the password has at least 6 characters and contains one uppercase letter
    return value.length >= 6 && value.contains(RegExp(r'[A-Z]'));
  }

  Future change_password() async {
    FirebaseFirestore.instance
        .collection("admin")
        .doc(FirebaseAuth.instance.currentUser!.email)
        .update({'password': changepassword.text});
  }

  final totalTransactionController = Get.put(Total_Transection());

  final UserController userController = Get.find<UserController>();
  final adminController = Get.put(AdminController());

  final TournamentController tournamentcontroller =
      Get.find<TournamentController>();
  @override
  void initState() {
    super.initState();
    totalTransactionController
        .fetchRegistrationRequests(); // Call the data-fetching function here
    totalTransactionController.calculateTotalFee();
  }

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
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom),
                            child: Form(
                              key: changepasswordkey,
                              child: SingleChildScrollView(
                                child: Column(
                                  children: [
                                    const SizedBox(
                                      height: 40,
                                    ),
                                    const Text(
                                        "Please enter your new password"),
                                    const SizedBox(
                                      height: 20,
                                    ),

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
                                        labelText: "Enter your password"),
                                    const SizedBox(
                                      height: 5,
                                    ),
                                    savebutton(
                                        onTap: () {
                                          if (changepasswordkey.currentState!
                                              .validate()) {
                                            change_password();
                                            Get.back();
                                            Get.snackbar("Meassage",
                                                "Your password is changed");
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
        body: Center(
          child: Column(
            children: <Widget>[
              StreamBuilder(
                stream: userController.userStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int count = snapshot.data!.docs.length;
                    userController.totalUsers.value = count;

                    return GestureDetector(
                      onTap: () {
                        Get.to(const Show_User());
                      },
                      child: Container(
                        height: 130,
                        width: 300,
                        decoration: BoxDecoration(
                          color: AppColors.backgroundColor,
                          borderRadius:
                              BorderRadius.circular(20), // Rounded corners
                        ),
                        child: Obx(() => Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: <Widget>[
                                  const Icon(
                                    Icons.person,
                                    size: 50,
                                    color: AppColors.successColor,
                                  ),
                                  const SizedBox(width: 10),
                                  Text(
                                    "Total users: ${userController.totalUsers.value}",
                                    style: const TextStyle(fontSize: 20),
                                  ),
                                ],
                              ),
                            )),
                      ),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return const CircularProgressIndicator(); // Loading indicator while data is being fetched.
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              StreamBuilder(
                stream: tournamentcontroller.tournamentStream,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    int count = snapshot.data!.docs.length;
                    tournamentcontroller.totalTournaments.value = count;

                    return Container(
                      width: 300,
                      height: 130,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius:
                            BorderRadius.circular(20), // Rounded corners
                      ),
                      child: Obx(() => Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                const Icon(
                                  Icons.sports_soccer,
                                  size: 50,
                                  color: Color.fromARGB(255, 255, 64, 198),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  "Total tournaments: ${tournamentcontroller.totalTournaments.value}",
                                  style: const TextStyle(fontSize: 20),
                                ),
                              ],
                            ),
                          )),
                    );
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    return const CircularProgressIndicator(); // Loading indicator while data is being fetched.
                  }
                },
              ),
              const SizedBox(
                height: 20,
              ),
              FutureBuilder<int>(
                future: totalTransactionController.calculateTotalFee(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator(); // Loading indicator while data is being fetched.
                  } else if (snapshot.hasError) {
                    return Text("Error: ${snapshot.error}");
                  } else {
                    final totalTransactionFee = snapshot.data ?? 0.0;
                    return Container(
                      height: 130,
                      width: 300,
                      decoration: BoxDecoration(
                        color: AppColors.backgroundColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            const Icon(
                              Icons.attach_money,
                              size: 50,
                              color: AppColors.successColor,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "Total Transaction: $totalTransactionFee",
                              style: const TextStyle(fontSize: 20),
                            ),
                          ],
                        ),
                      ),
                    );
                  }
                },
              )
            ],
          ),
        ));
  }
}
