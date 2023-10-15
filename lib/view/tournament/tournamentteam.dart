import 'package:admin/utils/colors.dart';
import 'package:admin/view/tournament/Tournament_Player_Details.dart';
import 'package:admin/widget/Build_Card.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TournamentTeam extends StatefulWidget {
  final sportname;
  const TournamentTeam({Key? key, required this.sportname}) : super(key: key);

  @override
  _TournamentTeamState createState() => _TournamentTeamState();
}

Future<DocumentSnapshot?> getPlayerDocument(String playerName) async {
  final QuerySnapshot query = await FirebaseFirestore.instance
      .collection('users')
      .where('fullname', isEqualTo: playerName)
      .get();

  if (query.docs.isNotEmpty) {
    return query.docs.first;
  } else {
    return null;
  }
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
                                          GestureDetector(
                                            onTap: () {
                                              _navigateToPlayerProfile(player);
                                            },
                                            child: FutureBuilder(
                                              future: getPlayerDocument(player),
                                              builder:
                                                  (context, playerSnapshot) {
                                                if (playerSnapshot
                                                        .connectionState ==
                                                    ConnectionState.waiting) {
                                                  return const CircularProgressIndicator();
                                                }
                                                if (playerSnapshot.hasData) {
                                                  var user = playerSnapshot
                                                          .data!
                                                          .data()
                                                      as Map<String, dynamic>;
                                                  var imageUrl =
                                                      user['Imageurl'];
                                                  return BuildCard(
                                                    player: player,
                                                    imageUrl:
                                                        imageUrl, // Pass the image URL to BuildCard
                                                  );
                                                } else {
                                                  return const Text(
                                                      'User not found');
                                                }
                                              },
                                            ),
                                          ),
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

  // Function to navigate to player profile page
  void _navigateToPlayerProfile(String playerName) async {
    final playerDocument = await getPlayerDocument(playerName);
    if (playerDocument != null) {
      // Navigate to player profile page with playerDocument

      Get.to(PlayerProfile(playerDocument: playerDocument));
    } else {
      Get.snackbar("Error", "Player does not exist",
          backgroundColor: AppColors.errorColor, colorText: Colors.white);
      // Handle the case where the player's details are not found
    }
  }
}
