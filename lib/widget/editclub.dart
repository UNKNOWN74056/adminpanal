import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import '../GETX/Bttomsheetgetx.dart';
import "package:get/get.dart";
import '../widgets/savebutton.dart';
import '../widgets/textform.dart';

class editclubpage extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> data;
  const editclubpage({super.key, required this.data});

  @override
  State<editclubpage> createState() => _editclubpageState();
}

class _editclubpageState extends State<editclubpage> {
  String imageUrl = "";
  @override
  void initState() {
    super.initState();
    // Pre-fill form fields with existing data
    final data = widget.data;
    Controller.clubcontroller.text = data['Clubname'] as String;
    Controller.emailcontroller.text = data['Email'] as String;
    Controller.loactioncontroller.text = data['Location'] as String;
    Controller.sportcontroller.text = data['sport'] as String;
    Controller.phonecontroller.text = data['Phone'] as String;
    Controller.ratingcontroller.text = data['rating'] as String;
    imageUrl = data['Clubimage'] as String;
  }

  //getx Controller
  final Controller = Get.put(Bttomsheetgetx());
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
    String email = Controller.emailcontroller.text.toString();
    var refer = await FirebaseStorage.instance
        .ref("/MrSport$email")
        .child('profileimage')
        .putFile(_image!.absolute);
    TaskSnapshot uploadTask = refer;
    await Future.value(uploadTask);
    var newUrl = await refer.ref.getDownloadURL();
    updateClubDetails(
        Controller.clubcontroller.value.text,
        Controller.emailcontroller.value.text,
        Controller.loactioncontroller.value.text,
        Controller.sportcontroller.value.text,
        Controller.phonecontroller.value.text,
        newUrl.toString(),
        Controller.ratingcontroller.value.text);
  }

  //adding club details
  Future updateClubDetails(
    String clubname,
    String email,
    String location,
    String sport,
    String phonecontect,
    String imageurl,
    String rating,
  ) async {
    await FirebaseFirestore.instance.collection('clubs').doc(email).update({
      'Clubname': clubname,
      'Email': email,
      'Location': location,
      'sport': sport,
      'Phone': phonecontect,
      'Clubimage': imageurl,
      'rating': rating
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.only(top: 30),
            child: Form(
              key: Controller.keyForm,
              child: Container(
                margin: const EdgeInsets.all(20),
                padding: const EdgeInsets.all(8),
                child: Column(
                  children: [
                    const Text("PLease file these details"),
                    GestureDetector(
                      onTap: () async {
                        dialogAlert(context);
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(top: 15),
                        child: Container(
                          child: _image == null
                              ? imageUrl.isEmpty // Check if imageUrl is empty
                                  ? CircleAvatar(
                                      radius: 60,
                                      child: Image.asset(
                                        "assets/logo.png",
                                        height: 90,
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : CircleAvatar(
                                      radius: 60,
                                      backgroundImage: NetworkImage(
                                          imageUrl), // Use imageUrl
                                      backgroundColor: Colors.white,
                                    )
                              : Image.file(
                                  _image!.absolute,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                    ),

                    const SizedBox(
                      height: 10,
                    ),
                    //textfields with dailog
                    reusebletextfield(
                        controller: Controller.clubcontroller,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboard: TextInputType.name,
                        validator: (Value) {
                          return Controller.validclubname(Value!);
                        },
                        icon: const Icon(FontAwesomeIcons.clipboardUser),
                        labelText: "Enter club name"),
                    const SizedBox(
                      height: 5,
                    ),

                    reusebletextfield(
                        controller: Controller.loactioncontroller,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboard: TextInputType.text,
                        validator: (Value) {
                          return Controller.validlocation(Value!);
                        },
                        icon: const Icon(FontAwesomeIcons.locationDot),
                        labelText: "Enter location"),
                    const SizedBox(
                      height: 5,
                    ),
                    reusebletextfield(
                        controller: Controller.sportcontroller,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboard: TextInputType.text,
                        validator: (Value) {
                          return Controller.validsport(Value!);
                        },
                        icon: const Icon(FontAwesomeIcons.locationDot),
                        labelText: "Enter sport"),
                    const SizedBox(
                      height: 5,
                    ),
                    reusebletextfield(
                        controller: Controller.phonecontroller,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboard: TextInputType.phone,
                        validator: (Value) {
                          return Controller.validphone(Value!);
                        },
                        icon: const Icon(FontAwesomeIcons.phone),
                        labelText: "+ code phone number"),
                    const SizedBox(
                      height: 15,
                    ),
                    reusebletextfield(
                        controller: Controller.ratingcontroller,
                        autoValidateMode: AutovalidateMode.onUserInteraction,
                        keyboard: TextInputType.number,
                        validator: (value) {
                          return Controller.validateRating(value);
                        },
                        icon: const Icon(FontAwesomeIcons.star),
                        labelText: "Enter rating"),
                    const SizedBox(
                      height: 15,
                    ),

                    //button to add the clubs and save in database
                    savebutton(
                      onTap: () async {
                        Controller.checkbottomsheet();

                        if (_image == null) {
                          // Show an error message that the user needs to select an image first.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select an image first."),
                            ),
                          );
                        } else if (Controller.isformValidated == true) {
                          String clubname =
                              Controller.clubcontroller.text.toString();
                          String email =
                              Controller.emailcontroller.text.toString();

                          String location =
                              Controller.loactioncontroller.text.toString();
                          String sport =
                              Controller.sportcontroller.text.toString();
                          String phone =
                              Controller.phonecontroller.text.toString();
                          String image = imageUrl.toString();
                          String rating =
                              Controller.ratingcontroller.text.toString();

                          updateClubDetails(clubname, email, location, sport,
                              phone, image, rating);

                          Get.back();
                          Get.snackbar("Message", "The club has been updated");
                        }
                      },
                      child: const Text("Save changes"),
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
