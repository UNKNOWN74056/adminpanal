import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:get/get.dart";
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../GETX/tournament.dart';
import 'package:intl/intl.dart';
import '../widgets/savebutton.dart';
import '../widgets/textform.dart';

class tournamentaddition extends StatefulWidget {
  const tournamentaddition({super.key});

  @override
  State<tournamentaddition> createState() => _tournamentadditionState();
}

class _tournamentadditionState extends State<tournamentaddition> {
  //tournament getx controller
  final tourcontroller = Get.put(tournamentgetx());

  Future addtournmant(
    String tournamentname,
    String tournamentlocation,
    String tournamentsport,
    String tournamentimage,
    String startdate,
    String enddate,
    String price,
    String email,
  ) async {
    await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(tourcontroller.email_controller.text)
        .set({
      'tournamentname': tourcontroller.Tournament_Name.value,
      'tournamentlocation': tourcontroller.Tournament_Location.value,
      'tournamentsport': tourcontroller.Tournament_Sport.value,
      'tournamentimage': tournamentimage,
      'startdate': tourcontroller.start_date.value,
      'enddate': tourcontroller.end_date.value,
      'price': tourcontroller.price.value,
      'email': tourcontroller.email.value,
    });
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero, () {
      tourcontroller.Tournament_Name_controller.text = "";
      tourcontroller.Tournament_Location_controller.text = "";
      tourcontroller.Tournament_Sport_controller.text = "";
      tourcontroller.start_date_controller.text = "";
      tourcontroller.end_date_controller.text = "";
      tourcontroller.email_controller.text = "";
      tourcontroller.price_controller.text = "";
    });
  }

  File? _image;
  final ImagePicker picker = ImagePicker();

  Future add_start_date() async {
    DateTime? pickeddate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    if (pickeddate != null) {
      setState(() {
        String format =
            DateFormat('yyyy-MM-dd').format(pickeddate); // Update format
        tourcontroller.start_date_controller.text =
            format.toString(); // Update controller
      });
    }
  }

  Future add_end_date() async {
    DateTime? pickeddate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2023),
        lastDate: DateTime(2025));
    if (pickeddate != null) {
      setState(() {
        String format =
            DateFormat('yyyy-MM-dd').format(pickeddate); // Update format
        tourcontroller.end_date_controller.text =
            format.toString(); // Update controller
      });
    }
  }

  Future addtour() async {
    String email = tourcontroller.email_controller.text.toString();
    var refer = await FirebaseStorage.instance
        .ref("/MrSport$email")
        .child('tournamentimage')
        .putFile(_image!.absolute);
    TaskSnapshot uploadTask = refer;
    await Future.value(uploadTask);
    var newUrl = await refer.ref.getDownloadURL();
    addtournmant(
      tourcontroller.Tournament_Name_controller.value.text,
      tourcontroller.Tournament_Location_controller.value.text,
      tourcontroller.Tournament_Sport_controller.value.text,
      newUrl.toString(),
      tourcontroller.start_date_controller.value.text,
      tourcontroller.end_date_controller.value.text,
      tourcontroller.price_controller.value.text,
      tourcontroller.email_controller.value.text,
    );
  }

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            margin: const EdgeInsets.all(20),
            padding: const EdgeInsets.all(8),
            child: SingleChildScrollView(
              child: Column(children: [
                Form(
                    key: tourcontroller.tourkeyForm,
                    child: SingleChildScrollView(
                        child: Column(children: [
                      const SizedBox(
                        height: 40,
                      ),
                      const Text("PLease fill these fields"),
                      const SizedBox(
                        height: 20,
                      ),
                      GestureDetector(
                        onTap: () async {
                          dialogAlert(context);
                        },
                        child: Container(
                          child: _image == null
                              ? CircleAvatar(
                                  radius: 60,
                                  child: Image.asset(
                                    "assets/logo.png",
                                    height: 90,
                                    fit: BoxFit.cover,
                                  ))
                              : Image.file(
                                  _image!.absolute,
                                  height: 100,
                                  width: 100,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      reusebletextfield(
                          controller: tourcontroller.Tournament_Name_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          keyboard: TextInputType.name,
                          validator: (Value) {
                            return tourcontroller.validtourname(Value!);
                          },
                          icon: const Icon(FontAwesomeIcons.clipboardUser),
                          labelText: "Enter tournamanet name"),
                      const SizedBox(
                        height: 5,
                      ),
                      reusebletextfield(
                          controller:
                              tourcontroller.Tournament_Location_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          keyboard: TextInputType.name,
                          validator: (Value) {
                            return tourcontroller.validtourlocation(Value!);
                          },
                          icon: const Icon(FontAwesomeIcons.locationDot),
                          labelText: "Enter tournament location"),
                      const SizedBox(
                        height: 5,
                      ),
                      reusebletextfield(
                          controller:
                              tourcontroller.Tournament_Sport_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          keyboard: TextInputType.name,
                          validator: (Value) {
                            return tourcontroller.validtoursport(Value!);
                          },
                          icon: const Icon(FontAwesomeIcons.futbol),
                          labelText: "Enter your tournament sports"),
                      const SizedBox(
                        height: 5,
                      ),
                      reusebletextfield(
                          controller: tourcontroller.email_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          keyboard: TextInputType.emailAddress,
                          validator: (Value) {
                            return tourcontroller.validEmail(Value!);
                          },
                          icon: const Icon(FontAwesomeIcons.solidEnvelope),
                          labelText: "Enter tournament email"),
                      const SizedBox(
                        height: 5,
                      ),
                      reusebletextfield(
                          controller: tourcontroller.start_date_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          // keyboard: TextInputType.datetime,
                          validator: (Value) {
                            return tourcontroller.validstartdate(Value!);
                          },
                          icon: const Icon(Icons.schedule),
                          sufix: GestureDetector(
                              onTap: () {
                                add_start_date();
                              },
                              child: const Icon(FontAwesomeIcons.calendar)),
                          labelText: "Enter your start date"),
                      const SizedBox(
                        height: 5,
                      ),
                      reusebletextfield(
                          controller: tourcontroller.end_date_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          //keyboard: TextInputType.datetime,
                          validator: (Value) {
                            return tourcontroller.validenddate(Value!);
                          },
                          icon: const Icon(Icons.schedule),
                          sufix: GestureDetector(
                              onTap: () {
                                add_end_date();
                              },
                              child: const Icon(FontAwesomeIcons.calendar)),
                          labelText: "Enter your end date"),
                      const SizedBox(
                        height: 5,
                      ),
                      reusebletextfield(
                          controller: tourcontroller.price_controller,
                          autoValidateMode: AutovalidateMode.onUserInteraction,
                          keyboard: TextInputType.number,
                          validator: (Value) {
                            return tourcontroller.valideprice(Value!);
                          },
                          icon: const Icon(Icons.attach_money),
                          labelText: "Enter your tournament price"),
                      const SizedBox(
                        height: 5,
                      ),
                      savebutton(
                          onTap: () {
                            tourcontroller.checktourbottomsheet();
                            try {
                              if (_image == null) {
                                // Show an error message that the user needs to select an image first.
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content:
                                        Text("Please select an image first."),
                                  ),
                                );
                              } else if (tourcontroller.isformValide == true) {
                                addtour();
                                Get.back();
                                Get.snackbar(
                                    'Message', 'The tournament has been added',
                                    backgroundColor: Colors.green,
                                    colorText: Colors.white);
                              }
                            } catch (e) {
                              Get.snackbar(
                                  'Error', 'Error while adding tournament.',
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            }
                          },
                          child: const Text("Add"))
                    ])))
              ]),
            )));
  }
}
