import 'package:admin/GETX/Total_Tournmaent.dart';
import 'package:admin/GETX/Total_Tournmaents.dart';
import 'package:admin/GETX/Total_Transection.dart';
import 'package:admin/utils/colors/App_Colors.dart';
import 'package:admin/user/Show_User.dart';
import 'package:admin/view/Login_page.dart';
import 'package:admin/widget/adminapprove.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the Firestore library

class Users extends StatefulWidget {
  const Users({super.key});

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final totalTransactionController = Get.put(Total_Transection());

  final UserController userController = Get.find<UserController>();

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
            padding: EdgeInsets.zero,
            children: <Widget>[
              const UserAccountsDrawerHeader(
                accountName: Text(
                  "Sports",
                  style: TextStyle(fontSize: 20),
                ),
                accountEmail: Text("Sports@gmail.com"),
              ),
              const ListTile(
                leading: Icon(Icons.lock),
                title: Text("Change passwrod"),
              ),
              const SizedBox(
                height: 20,
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
              const SizedBox(
                height: 20,
              ),
            ],
          ),
        ),
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
