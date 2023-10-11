import 'package:admin/view/user/fetchvideodata.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Detail_Page extends StatefulWidget {
  final post;
  const Detail_Page({super.key, required this.post});

  @override
  State<Detail_Page> createState() => _Detail_PageState();
}

//getx controller
final vidcontroller = Get.put(FetchVideoFirebase());
final List<VideoPlayerController> _controllers = [];

class _Detail_PageState extends State<Detail_Page> {
  final CollectionReference offersCollection =
      FirebaseFirestore.instance.collection('offers');

  Future<void> showApprovedOffers() async {
    // Fetch approved offers from Firestore
    final QuerySnapshot querySnapshot =
        await offersCollection.where('isApproved', isEqualTo: true).get();

    // Prepare a list of offers to display
    final List<Map<String, dynamic>> approvedOffers = querySnapshot.docs
        .map((doc) => doc.data() as Map<String, dynamic>)
        .toList();

    // Show the offers in a dialog
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Players'),
          content: Column(
            children: approvedOffers.map((offer) {
              return Card(
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(offer[
                        'image']), // Replace with the image URL in your data
                  ),
                  title: Text(offer['fullname']),
                  subtitle: Text(offer['sport']),
                  // Add more widgets as needed
                ),
              );
            }).toList(),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            const SizedBox(height: 10.0),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Player Detail"),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  CircleAvatar(
                    radius: 60.0,
                    backgroundImage: NetworkImage(widget.post['Imageurl']),
                  ),
                  const SizedBox(height: 10.0),
                  Text(
                    widget.post['fullname'],
                    style: const TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.post['sport'],
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                  const SizedBox(height: 5.0),
                  Text(
                    widget.post['rating'].toString(),
                    style: const TextStyle(
                      fontSize: 16.0,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10.0),
            ListTile(
              leading: const Icon(Icons.email),
              title: Text(widget.post['email']),
            ),
            const Divider(),
            ListTile(
                leading: const Icon(Icons.phone),
                title: Text(widget.post['phoneNumber'])),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.location_on),
              title: Text(widget.post['city']),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesomeIcons.venusMars),
              title: Text(widget.post['gender']),
            ),
            const Divider(),
            ListTile(
              leading: const Icon(FontAwesomeIcons.userTie),
              title: Text(widget.post['profession']),
            ),
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Videos',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  GridView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: vidcontroller.videolist
                        .where((e) => e.email == widget.post.email)
                        .length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 8.0,
                      crossAxisSpacing: 8.0,
                    ),
                    itemBuilder: (BuildContext context, int index) {
                      final video = vidcontroller.videolist
                          .where((e) => e.email == widget.post.email)
                          .toList()[index];
                      final controller =
                          VideoPlayerController.network(video.videolink);
                      _controllers.add(controller);
                      return GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Scaffold(
                                body: Chewie(
                                  controller: ChewieController(
                                    videoPlayerController: controller,
                                    autoPlay: true,
                                    looping: false,
                                    additionalOptions: (context) {
                                      return <OptionItem>[
                                        OptionItem(
                                          onTap: () {
                                            // Handle the action when the button is pressed
                                          },
                                          iconData: FontAwesomeIcons.trash,
                                          title: "Delete",
                                        ),
                                      ];
                                    },
                                    errorBuilder: (context, errorMessage) {
                                      return Center(
                                        child: Text(
                                          errorMessage,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      );
                                    },
                                    placeholder: Container(
                                      color: Colors.grey[200],
                                    ),
                                    materialProgressColors:
                                        ChewieProgressColors(
                                      playedColor: Colors.red,
                                      handleColor: Colors.red,
                                      backgroundColor: const Color.fromARGB(
                                          78, 158, 158, 158),
                                      bufferedColor: Colors.grey,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(8.0),
                          decoration: BoxDecoration(
                            color: Colors.white70,
                            borderRadius: BorderRadius.circular(8.0),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 1,
                                blurRadius: 5,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: FutureBuilder(
                            future: controller.initialize(),
                            builder:
                                (BuildContext context, AsyncSnapshot snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.done) {
                                return AspectRatio(
                                  aspectRatio: 16 / 9,
                                  child: VideoPlayer(controller),
                                );
                              } else if (snapshot.hasError) {
                                return const Text('Error loading video');
                              } else {
                                return Container(
                                  height: 200.0,
                                  color: Colors.grey[200],
                                );
                              }
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),

      floatingActionButton: widget.post['profession'] == 'Coache'
          ? FloatingActionButton.extended(
              onPressed: () {
                showApprovedOffers();
              },
              label: const Text("Members"),
            )
          : null, // Set to null to hide the button if the condition is not met
    );
  }
}
