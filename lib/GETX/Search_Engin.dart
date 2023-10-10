import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class UserSearchEngine extends StatefulWidget {
  const UserSearchEngine({super.key});

  @override
  _UserSearchEngineState createState() => _UserSearchEngineState();
}

class _UserSearchEngineState extends State<UserSearchEngine> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              // Convert the search query to lowercase
              _searchQuery = value.toLowerCase();
            });
          },
          decoration: const InputDecoration(
            hintText: 'Search...',
            hintStyle: TextStyle(color: Colors.black),
          ),
          cursorHeight: 25.0,
          cursorColor: Colors.black,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('users').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Perform a case-insensitive search and filter results based on the searchQuery
          final filteredDocs = snapshot.data!.docs
              .where((document) =>
                  document['fullname'].toLowerCase().contains(_searchQuery))
              .toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final document = filteredDocs[index];
              return GestureDetector(
                onTap: () {
                  // Handle the tap on the user item.
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(document['Imageurl']),
                  ),
                  title: Text(document['fullname']),
                  subtitle: Text(document['email']),
                  trailing: const Icon(FontAwesomeIcons.arrowRight),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
