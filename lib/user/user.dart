import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart'; // Import the Firestore library

class Users extends StatefulWidget {
  const Users({Key? key}) : super(key: key);

  @override
  State<Users> createState() => _UsersState();
}

class _UsersState extends State<Users> {
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Initialize Firestore

  @override
  Widget build(BuildContext context) {
    // Create a Stream that listens to changes in the 'users' collection
    Stream<QuerySnapshot> userStream =
        _firestore.collection('users').snapshots();

    return Scaffold(
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
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(user['Imageurl']),
                    ),
                    title: Text(user['fullname']),
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
