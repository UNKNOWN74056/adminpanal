import 'dart:io';
import 'package:admin/GETX/Club_Search.dart';
import 'package:admin/GETX/clubGetx.dart';
import 'package:admin/view/clubs/addclubdata.dart';
import 'package:admin/view/clubs/clubdetails.dart';
import 'package:admin/widget/editclub.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class clubs extends StatefulWidget {
  const clubs({super.key});

  @override
  State<clubs> createState() => _clubsState();
}

class _clubsState extends State<clubs> {
  //getx controller
  final controller = Get.put(clubGetx());

//detail page of club
  navigatetodetail(DocumentSnapshot post) {
    Get.to(clubdetail(post: post));
  }

  File? _image;
  final ImagePicker picker = ImagePicker();

  //pick image from gallery
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Get.snackbar("Error", "please select the image");
      }
    });
  }

  // pick image from camera
  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        Get.snackbar("Error", "please select the image");
      }
    });
  }

  //alertdailog for image to be select from camera or gallery
  void dialogAlert(context) async {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            content: SizedBox(
              height: 120,
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      getCameraImage();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.camera_alt),
                      title: Text("Camera"),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      getImageGallery();
                      Navigator.pop(context);
                    },
                    child: const ListTile(
                      leading: Icon(Icons.photo),
                      title: Text("Gallery"),
                    ),
                  ),
                ],
              ),
            ),
          );
        });
  }

  //add club function
  Future addclub() async {
    String email = controller.emailcontroller.text.toString();
    var refer = await FirebaseStorage.instance
        .ref("/MrSport$email")
        .child('profileimage')
        .putFile(_image!.absolute);
    TaskSnapshot uploadTask = refer;
    await Future.value(uploadTask);
    var newUrl = await refer.ref.getDownloadURL();
    addclubdetails(
        controller.clubcontroller.value.text,
        controller.emailcontroller.value.text,
        controller.loactioncontroller.value.text,
        controller.sportcontroller.value.text,
        controller.phonecontroller.value.text,
        newUrl.toString(),
        controller.ratingcontroller.value.text);
  }

  //adding club details
  Future addclubdetails(
    String clubname,
    String email,
    String location,
    String sport,
    String phonecontect,
    String imageurl,
    String rating,
  ) async {
    await FirebaseFirestore.instance.collection('clubs').doc(email).set({
      'Clubname': controller.clubname.value,
      'Email': controller.email.value,
      'Location': controller.location.value,
      'sport': controller.sport.value,
      'Phone': controller.phone.value,
      'Clubimage': imageurl,
      'rating': rating
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
            automaticallyImplyLeading: false,
            title: const Text("Club"),
            centerTitle: true,
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 20),
                child: GestureDetector(
                    onTap: () {
                      Get.to(const ClubSearch());
                    },
                    child: const Icon(Icons.search)),
              ),
            ]),
        //floating action button
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            //this is for to add club data
            Get.to(const clubaddition());
          },
          child: const Icon(Icons.add),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance.collection('clubs').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
              if (snapshot.hasData) {
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    shrinkWrap: true,
                    itemBuilder: (context, i) {
                      var data = snapshot.data!.docs[i];
                      return Slidable(
                        endActionPane:
                            ActionPane(motion: const ScrollMotion(), children: [
                          SlidableAction(
                            onPressed: (context) {
                              //this is for update the club data
                              Get.to(editclubpage(data: data));
                            },
                            backgroundColor: const Color(0xFF7BC043),
                            foregroundColor: Colors.white,
                            icon: Icons.edit,
                            label: 'Edit',
                          ),
                          SlidableAction(
                            onPressed: (context) {
                              // this is for to delete the club
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
                                                  "Club has been deleted",
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
                                const Color.fromARGB(255, 241, 39, 12),
                            foregroundColor: Colors.white,
                            icon: FontAwesomeIcons.trash,
                            label: 'Delete',
                          ),
                        ]),
                        child: Column(
                          children: [
                            GestureDetector(
                                onTap: () => navigatetodetail(data),
                                child: Card(
                                  color: Colors.grey.shade300,
                                  shape: RoundedRectangleBorder(
                                    side: const BorderSide(
                                        color: Color.fromARGB(255, 25, 9, 117),
                                        width: 1),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: ListTile(
                                    title: Text(data["Clubname"],
                                        style: const TextStyle(fontSize: 20)),
                                    leading: CircleAvatar(
                                        radius: 35,
                                        backgroundImage:
                                            CachedNetworkImageProvider(
                                                data['Clubimage']),
                                        backgroundColor: Colors.white),
                                    subtitle: Text(data["Location"],
                                        style: const TextStyle(fontSize: 15)),
                                    trailing:
                                        const Icon(FontAwesomeIcons.arrowRight),
                                  ),
                                )),
                          ],
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
