import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Tournament_search extends StatefulWidget {
  const Tournament_search({super.key});

  @override
  _Tournament_searchState createState() => _Tournament_searchState();
}

class _Tournament_searchState extends State<Tournament_search> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          onChanged: (value) {
            setState(() {
              _searchQuery =
                  value.toLowerCase(); // Convert the search query to lowercase
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
        stream:
            FirebaseFirestore.instance.collection('tournaments').snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          // Perform a case-insensitive search and filter results based on the searchQuery
          final filteredDocs = snapshot.data!.docs
              .where((document) => document['tournamentname']
                  .toLowerCase()
                  .contains(_searchQuery))
              .toList();

          return ListView.builder(
            itemCount: filteredDocs.length,
            itemBuilder: (BuildContext context, int index) {
              final document = filteredDocs[index];
              return GestureDetector(
                onTap: () {},
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(document['tournamentimage']),
                  ),
                  title: Text(document['tournamentname']),
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
