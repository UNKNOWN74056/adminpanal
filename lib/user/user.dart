import 'package:admin/GETX/Total_Tournmaent.dart';
import 'package:admin/GETX/Total_Tournmaents.dart';
import 'package:admin/colors/App_Colors.dart';
import 'package:admin/user/Show_User.dart';
import 'package:admin/widget/adminapprove.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the Firestore library

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final UserController userController = Get.find<UserController>();
  final TournamentController tournamentcontroller =
      Get.find<TournamentController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: Drawer(
          child: ListView(
            padding: EdgeInsets.zero,
            children: const <Widget>[
              UserAccountsDrawerHeader(
                accountName: Text(
                  "Sports",
                  style: TextStyle(fontSize: 20),
                ),
                accountEmail: Text("Sports@gmail.com"),
              ),
              ListTile(
                leading: Icon(Icons.lock),
                title: Text("Change passwrod"),
              ),
              SizedBox(
                height: 20,
              ),
              ListTile(
                leading: Icon(
                  Icons.logout,
                  color: Colors.green,
                ),
                title: Text("Log out"),
              ),
              SizedBox(
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
              Container(
                height: 130,
                width: 300,
                decoration: BoxDecoration(
                  color: AppColors.backgroundColor,
                  borderRadius: BorderRadius.circular(20), // Rounded corners
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
                        "Total Transaction: ${tournamentcontroller.totalTournaments.value}",
                        style: const TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
