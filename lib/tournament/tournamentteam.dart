import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentTeam extends StatefulWidget {
  final sportname;
  const TournamentTeam({Key? key, required this.sportname}) : super(key: key);

  @override
  _TournamentTeamState createState() => _TournamentTeamState();
}

class _TournamentTeamState extends State<TournamentTeam> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Tournament Teams'),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('registrationRequests')
            .where('sportevent', isEqualTo: widget.sportname)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final teams = snapshot.data!.docs;

          // Use the teams data to build your ListView
          return ListView.builder(
            itemCount: teams.length,
            itemBuilder: (context, index) {
              var team = teams[index].data() as Map<String, dynamic>;
              return Card(
                // Customize the card widget to display team data
                child: ListTile(
                  title: Text('Team Name: ${team['teamName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Captain: ${team['captainName']}'),
                      Text('City: ${team['city']}'), // Add City
                      // Add more team information as needed
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
