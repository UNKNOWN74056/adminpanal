import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Deleteion_Requests extends StatefulWidget {
  const Deleteion_Requests({Key? key}) : super(key: key);

  @override
  State<Deleteion_Requests> createState() => _Deleteion_RequestsState();
}

class _Deleteion_RequestsState extends State<Deleteion_Requests> {
  String? acceptedRequestId;
  String? rejectedRequestId;

  void acceptDeletionRequest(String requestby) {
    FirebaseFirestore.instance
        .collection('deletionRequests')
        .doc(requestby)
        .update({
      'status': true,
    }).then((_) {
      setState(() {
        acceptedRequestId = requestby;
        rejectedRequestId = null;
      });
      print('Request accepted.');
    }).catchError((error) {
      print('Error accepting request: $error');
    });
  }

  void rejectDeletionRequest(String requestby) {
    FirebaseFirestore.instance
        .collection('deletionRequests')
        .doc(requestby)
        .update({
      'status': false,
    }).then((_) {
      setState(() {
        acceptedRequestId = null;
        rejectedRequestId = requestby;
      });
      print('Request rejected.');
    }).catchError((error) {
      print('Error rejecting request: $error');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('deletionRequests')
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error.toString()}'));
          } else if (snapshot.hasData && snapshot.data!.docs.isEmpty) {
            return const Center(child: Text('No deletion requests available.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                var request = snapshot.data!.docs[index];
                var fullName = request['fullname'];
                var image = request['image'];
                var profession = request['profession'];
                var sport = request['sport'];
                var requestby = request['requesterby'];
                bool isAccepted = requestby == acceptedRequestId;
                bool isRejected = requestby == rejectedRequestId;

                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundImage: NetworkImage(image),
                    ),
                    title: Text(fullName),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(profession),
                        Text(sport),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        if (!isAccepted && !isRejected)
                          GestureDetector(
                            onTap: () {
                              acceptDeletionRequest(requestby);
                            },
                            child: const Icon(
                              Icons.check,
                              color: Colors.green,
                            ),
                          ),
                        const SizedBox(width: 8),
                        if (!isAccepted && !isRejected)
                          GestureDetector(
                            onTap: () {
                              rejectDeletionRequest(requestby);
                            },
                            child: const Icon(
                              Icons.close,
                              color: Colors.red,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
