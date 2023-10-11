import 'package:admin/GETX/Tournament_search.dart';
import 'package:admin/view/tournament/addtournament.dart';
import 'package:admin/view/tournament/tournamentteam.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '../../widget/edittournmaent.dart';
import "package:intl/intl.dart";

class turnaments extends StatefulWidget {
  const turnaments({super.key});

  @override
  State<turnaments> createState() => _turnamentsState();
}

class _turnamentsState extends State<turnaments> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: const Text("Tournaments"),
          actions: [
            Padding(
              padding: const EdgeInsets.only(right: 20),
              child: GestureDetector(
                  onTap: () {
                    Get.to(const Tournament_search());
                  },
                  child: const Icon(Icons.search)),
            ),
          ],
        ),
        //floating action button
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.to(const tournamentaddition());
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('tournaments')
                .snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      var data = snapshot.data!.docs[i];
                      //changing timestamp to datetime object
                      Timestamp startDateTimestamp = data['startdate'];
                      Timestamp endDateTimestamp = data['enddate'];
                      DateTime startDate = startDateTimestamp.toDate();
                      DateTime endDate = endDateTimestamp.toDate();
                      ////////////////////////////////////////////////
                      return Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {
                              Get.to(edittournament(data: data));
                            },
                            backgroundColor: const Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              showDialog(
                                  context: context,
                                  builder: (context) {
                                    return AlertDialog(
                                      title: const Text("Delete Club"),
                                      content: const Text(
                                          "Are you sure you want to delete?"),
                                      actions: [
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Cancel")),
                                        TextButton(
                                            onPressed: () async {
                                              await data.reference.delete();
                                              Get.snackbar("Message",
                                                  "Tournament has been deleted",
                                                  backgroundColor: Colors.red,
                                                  colorText: Colors.white);
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text("Yes")),
                                      ],
                                    );
                                  });
                            },
                            backgroundColor:
                                const Color.fromARGB(255, 240, 12, 12),
                            foregroundColor: Colors.white,
                            icon: FontAwesomeIcons.trash,
                            label: 'Delete',
                          ),
                        ]),
                        child: GestureDetector(
                          onTap: (() {
                            Get.to(TournamentTeam(
                                sportname: data['tournamentname']));
                          }),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 10, right: 10),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade300,
                                      border: Border.all(),
                                      borderRadius: BorderRadius.circular(15)),
                                  height: 210,
                                  width: MediaQuery.of(context).size.width,
                                  child: Column(
                                    children: [
                                      const SizedBox(
                                        height: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            CircleAvatar(
                                              radius: 25,
                                              backgroundImage: NetworkImage(
                                                  data['tournamentimage']),
                                            ),
                                            Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 10),
                                                  child: Text(
                                                    data['tournamentname'],
                                                    style: const TextStyle(
                                                        fontSize: 20,
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          left: 0),
                                                  child: Text(data[
                                                      'tournamentlocation']),
                                                )
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                left: 10, top: 10),
                                            child: Row(
                                              children: [
                                                const Icon(
                                                  Icons.schedule,
                                                  color: Colors.green,
                                                ),
                                                const SizedBox(width: 5),
                                                const Text(
                                                  "Start At:",
                                                  style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                Text(DateFormat(
                                                        'yyyy-MM-dd HH:mm')
                                                    .format(startDate)),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(
                                        height: 10,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.schedule,
                                              color: Colors.red,
                                            ),
                                            const Text(
                                              "End At: ",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(DateFormat('yyyy-MM-dd HH:mm')
                                                .format(endDate)),
                                          ],
                                        ),
                                      ),
                                      const SizedBox(height: 10),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10),
                                        child: Row(
                                          children: [
                                            const Icon(
                                              Icons.attach_money,
                                              color: Colors.green,
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              'Price Pool:',
                                              style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            Text(
                                              data['price'].toString(),
                                              style: const TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 16,
                                                color: Colors.green,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    });
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ),
    );
  }
}