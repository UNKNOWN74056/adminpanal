import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Club_Members extends StatefulWidget {
  final String clubName;

  const Club_Members({Key? key, required this.clubName}) : super(key: key);

  @override
  State<Club_Members> createState() => _Club_MembersState();
}

class _Club_MembersState extends State<Club_Members> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Club Members'),
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: FirebaseFirestore.instance
            .collection('users')
            .where('club', isEqualTo: widget.clubName)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
                child: CircularProgressIndicator()); // Loading indicator
          }

          if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return const Center(
              child: Text('No members found for this club.'),
            );
          }

          // Display members in cards
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              var user = snapshot.data!.docs[index];
              return Card(
                margin: const EdgeInsets.all(10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(
                        user['Imageurl']), // Replace with the user's image URL
                  ),
                  title: Text(user['fullname']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          Text(user['rating']
                              .toString()), // Assuming 'rating' is a double
                        ],
                      ),
                      Text(
                        user['city'],
                      ),
                    ],
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
