import 'package:admin/GETX/Search_Engin.dart';
import 'package:admin/view/user/User_Detail_Page.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:get/get.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Show_User extends StatefulWidget {
  const Show_User({super.key});

  @override
  State<Show_User> createState() => _Show_UserState();
}

class _Show_UserState extends State<Show_User> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Initialize Firestore
  // Create a Stream that listens to changes in the 'users' collection

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> userStream =
        _firestore.collection('users').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: const Text("Users"),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: GestureDetector(
                onTap: () {
                  Get.to(const UserSearchEngine());
                },
                child: const Icon(Icons.search)),
          ),
        ],
      ),
      body: StreamBuilder(
        stream: userStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(child: Text("No users found."));
          }

          // Display the user data from the Firestore collection
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Slidable(
                endActionPane:
                    ActionPane(motion: const ScrollMotion(), children: [
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Account Disable"),
                              content: const Text(
                                  "Are you sure you want to disable this account?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Mark the user for deletion by updating Firestore document
                                    await user.reference
                                        .update({'markedForDeletion': true});

                                    Get.snackbar(
                                      "Message",
                                      "The account is disabled",
                                      backgroundColor: Colors.red,
                                      colorText: Colors.white,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          });
                    },
                    backgroundColor: const Color.fromARGB(255, 241, 39, 12),
                    foregroundColor: Colors.white,
                    icon: FontAwesomeIcons.ban,
                  ),
                  SlidableAction(
                    onPressed: (context) {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Account Enable"),
                              content: const Text(
                                  "Are you sure you want to enable this account?"),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Cancel"),
                                ),
                                TextButton(
                                  onPressed: () async {
                                    // Mark the user for deletion by updating Firestore document
                                    await user.reference
                                        .update({'markedForDeletion': false});

                                    Get.snackbar(
                                      "Message",
                                      "The account is enabled",
                                      backgroundColor: Colors.green,
                                      colorText: Colors.white,
                                    );
                                    Navigator.of(context).pop();
                                  },
                                  child: const Text("Yes"),
                                ),
                              ],
                            );
                          });
                    },
                    backgroundColor: const Color.fromARGB(255, 12, 241, 27),
                    foregroundColor: Colors.white,
                    icon: FontAwesomeIcons.check,
                  ),
                ]),
                child: Card(
                  elevation: 3, // Add shadow to the card
                  margin: const EdgeInsets.all(10),
                  child: ListTile(
                    onTap: () {
                      Get.to(Detail_Page(post: user));
                    },
                    leading: CircleAvatar(
                      backgroundImage:
                          CachedNetworkImageProvider(user['Imageurl']),
                    ),
                    title: Row(
                      children: [
                        Text(user['fullname']),
                        if (user['varification'])
                          const Icon(
                            FontAwesomeIcons.certificate,
                            color: Colors.blue,
                            size: 16,
                          ),
                      ],
                    ),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(user['profession']),
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.star,
                              color: Colors.yellow,
                            ),
                            Text(user['rating'].toString()),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
