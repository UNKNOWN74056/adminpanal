import 'dart:io';
import 'package:get/get.dart';
import 'package:admin/GETX/getclubdata.dart';
import 'package:admin/widgets/savebutton.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import '../GETX/fullscreen.dart';

class clubdetail extends StatefulWidget {
  final DocumentSnapshot post;

  const clubdetail({super.key, required this.post});

  @override
  State<clubdetail> createState() => _clubdetailState();
}

File? photo;
final ImagePicker picker = ImagePicker();

final updateclubname = TextEditingController();

class _clubdetailState extends State<clubdetail> {
  //getx controller
  final clubcontroller = Get.put(Getclubdata());
  double rating = 0;
  //pick image from gallery
  Future getImageGallery() async {
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        photo = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

// pick image from camera
  Future getCameraImage() async {
    final pickedFile = await picker.pickImage(source: ImageSource.camera);

    setState(() {
      if (pickedFile != null) {
        photo = File(pickedFile.path);
      } else {
        print("No Image Selected");
      }
    });
  }

  //dailog to select photo from camera or gallery
  void dialogAlert(context) {
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

  //add club photo function
  Future clubphoto() async {
    String fileName = photo!.path.split('/photos').last;
    Reference reference = FirebaseStorage.instance.ref().child(fileName);
    UploadTask uploadTask = reference.putFile(photo!);
    TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() => null);

    var photourl = await taskSnapshot.ref.getDownloadURL();
    //adding document to firstore database
    var docRef = FirebaseFirestore.instance.collection('clubphoto').doc();
    var id = docRef.id;
    await docRef.set({
      'clubphoto': photourl,
      'Email': widget.post['Email'],
      'id': id,
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showModalBottomSheet(
                isScrollControlled: true,
                shape: const RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.vertical(top: Radius.circular(10))),
                context: context,
                builder: (context) => Container(
                    margin: const EdgeInsets.all(20),
                    padding: const EdgeInsets.all(8),
                    child: Padding(
                        padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom),
                        child: SingleChildScrollView(
                            child: Column(children: [
                          const SizedBox(
                            height: 40,
                          ),
                          const Text("PLease select the photo"),
                          const SizedBox(
                            height: 20,
                          ),
                          GestureDetector(
                            onTap: () async {
                              dialogAlert(context);
                            },
                            child: photo == null
                                ? Column(
                                    children: [
                                      CircleAvatar(
                                        radius: 60,
                                        child: Image.asset(
                                          "assets/logo.png",
                                          height: 90,
                                          fit: BoxFit.cover,
                                        ),
                                      ),
                                    ],
                                  )
                                : Image.file(
                                    photo!.absolute,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          savebutton(
                            onTap: () {
                              if (photo == null) {
                                // Show an error message if the photo is not selected
                                Get.snackbar(
                                  "Error",
                                  "Please select a photo before saving",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white,
                                );
                              } else {
                                // Photo is selected, proceed with saving
                                clubphoto();
                                Get.back();
                                Get.snackbar(
                                  "Message",
                                  "The photo has been added",
                                  backgroundColor: Colors.green,
                                  colorText: Colors.white,
                                );
                              }
                            },
                            child: const Text("Add"),
                          ),
                        ])))));
          },
          label: const Text("Add photos"),
          icon: const Icon(Icons.photo),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Container(
                  height: 200,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: NetworkImage(widget.post['Clubimage']),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                SafeArea(
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.white,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        widget.post['Clubname'],
                        style: const TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.star, color: Colors.amber),
                          const SizedBox(width: 5),
                          Text(
                            widget.post['rating'],
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Sports: ", style: TextStyle(fontSize: 18)),
                      Text(
                        widget.post['sport'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Contact: ", style: TextStyle(fontSize: 18)),
                      Text(
                        widget.post['Phone'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      const Text("Email: ", style: TextStyle(fontSize: 18)),
                      Text(
                        widget.post['Email'],
                        style: const TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    'Photos',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection("clubphoto")
                      .where("Email", isEqualTo: widget.post['Email'])
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError) {
                      return const Text('Something went wrong');
                    }

                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Text("Loading....");
                    }

                    final photos = snapshot.data!.docs
                        .where((doc) => doc['Email'] == widget.post['Email'])
                        .map((doc) => {
                              'id': doc.id,
                              'photo': doc['clubphoto'],
                              'Email': doc['Email'],
                            })
                        .toList();

                    return GridView.builder(
                      itemCount: photos.length,
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        final photo = photos[index];
                        return InkWell(
                          onTap: () {
                            // Navigate to full-screen photo screen
                            Get.to(FullScreenPhoto(photo: photo['photo']));
                          },
                          onLongPress: () async {
                            // Show a dialog to confirm deletion
                            final confirm = await showDialog<bool>(
                              context: context,
                              builder: (context) => AlertDialog(
                                title: const Text('Confirm'),
                                content: const Text(
                                    'Are you sure you want to delete this photo?'),
                                actions: [
                                  TextButton(
                                    child: const Text('Cancel'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(false),
                                  ),
                                  TextButton(
                                    child: const Text('Delete'),
                                    onPressed: () =>
                                        Navigator.of(context).pop(true),
                                  ),
                                ],
                              ),
                            );
                            if (confirm != null && confirm) {
                              // Delete the photo from Firestore
                              FirebaseFirestore.instance
                                  .collection('clubphoto')
                                  .doc(photo['id'])
                                  .delete();
                            }
                          },
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: Image.network(
                              photo['photo'],
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
