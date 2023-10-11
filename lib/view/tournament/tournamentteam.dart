import 'package:admin/widget/Build_Card.dart';
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
                  onTap: () {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: const Text(
                            'Team Players',
                          ),
                          content: StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('registrationRequests')
                                .where('sportevent',
                                    isEqualTo: widget.sportname)
                                .snapshots(),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const Center(
                                    child: CircularProgressIndicator());
                              }
                              if (snapshot.hasData) {
                                return ListView.builder(
                                  itemCount: snapshot.data!.docs.length,
                                  itemBuilder: (context, i) {
                                    var data = snapshot.data!.docs[i];
                                    List<String> players = [
                                      data['player1'],
                                      data['player2'],
                                      data['player3'],
                                      data['player4'],
                                      data['player5'],
                                      data['player6'],
                                      data['player7'],
                                      data['player8'],
                                      data['player9'],
                                      data['player10'],
                                      data['player11'],
                                    ];

                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Divider(thickness: 1),
                                        for (String player in players)
                                          BuildCard(
                                            player: player,
                                          ) // Replace with player image URL
                                      ],
                                    );
                                  },
                                );
                              }
                              return const Text('No players found');
                            },
                          ),
                          actions: [
                            TextButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              child: const Text('Close'),
                            ),
                          ],
                        );
                      },
                    );
                  },
                  title: Text('Team Name: ${team['teamName']}'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Captain: ${team['captainName']}'),
                      Text('City: ${team['city']}'), // Add City
                      Text('Sport: ${team['sport']}'),
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
