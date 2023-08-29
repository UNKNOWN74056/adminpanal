import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import "package:flutter/material.dart";
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import "package:get/get.dart";
import 'package:firebase_storage/firebase_storage.dart';
import '../GETX/tournament.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'package:admin/widgets/savebutton.dart';
import '../widgets/textform.dart';

class edittournament extends StatefulWidget {
  final QueryDocumentSnapshot<Object?> data;
  const edittournament({super.key, required this.data});

  @override
  State<edittournament> createState() => _edittournamentState();
}

class _edittournamentState extends State<edittournament> {
  //tournament getx controller
  final tourcontroller = Get.put(tournamentgetx());
  //update controllers
  final TextEditingController _updatetourname = TextEditingController();
  final TextEditingController _updatetourlocation = TextEditingController();
  final TextEditingController _updatetoursport = TextEditingController();
  final TextEditingController _updatetourstartdate = TextEditingController();
  final TextEditingController _updatetourenddate = TextEditingController();
  final TextEditingController _updatetourprice = TextEditingController();
  String imageUrl = "";

  @override
  void initState() {
    super.initState();
    // Pre-fill form fields with existing data
    final data = widget.data;
    _updatetourname.text = data['tournamentname'] as String;
    _updatetourlocation.text = data['tournamentlocation'] as String;
    _updatetoursport.text = data['tournamentsport'] as String;
    // Convert Timestamp fields to strings using DateFormat
    Timestamp startDateTimestamp = data['startdate'] as Timestamp;
    Timestamp endDateTimestamp = data['enddate'] as Timestamp;
    _updatetourstartdate.text =
        DateFormat('yyyy-MM-dd').format(startDateTimestamp.toDate());
    _updatetourenddate.text =
        DateFormat('yyyy-MM-dd').format(endDateTimestamp.toDate());
    _updatetourprice.text = data['price'] as String;
    imageUrl = data['tournamentimage'] as String;
  }

  File? _image;
  final ImagePicker picker = ImagePicker();
  void add_start_date() async {
    DateTime? pickeddate = await showDatePicker(
      context: context,
      initialDate: DateFormat('yyyy-MM-dd').parse(_updatetourstartdate.text),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (pickeddate != null) {
      setState(() {
        String format = DateFormat('yyyy-MM-dd').format(pickeddate);
        _updatetourstartdate.text = format.toString();
      });
    }
  }

  void add_end_date() async {
    DateTime? pickeddate = await showDatePicker(
      context: context,
      initialDate: DateFormat('yyyy-MM-dd').parse(_updatetourstartdate.text),
      firstDate: DateTime(2023),
      lastDate: DateTime(2025),
    );

    if (pickeddate != null) {
      setState(() {
        String format = DateFormat('yyyy-MM-dd').format(pickeddate);
        _updatetourenddate.text = format.toString();
      });
    }
  }

  Future updatetour() async {
    String email = tourcontroller.email_controller.text.toString();
    var refer = await FirebaseStorage.instance
        .ref("/MrSport$email")
        .child('tournamentimage')
        .putFile(_image!.absolute);
    TaskSnapshot uploadTask = refer;
    await Future.value(uploadTask);
    var newUrl = await refer.ref.getDownloadURL();

    edittournamentdetails(
      _updatetourname.value.text,
      _updatetourlocation.value.text,
      _updatetoursport.value.text,
      _updatetourstartdate.text,
      _updatetourenddate.text,
      _updatetourprice.text,
      newUrl.toString(),
    );
  }

  Future edittournamentdetails(
      String tournamentname,
      String tournamentlocation,
      String tournamentsport,
      String tournamentimage,
      String startdate,
      String enddate,
      String price) async {
    // Convert updated date strings to Firestore Timestamps
    Timestamp startDateTimestamp =
        Timestamp.fromDate(DateTime.parse(startdate));
    Timestamp endDateTimestamp = Timestamp.fromDate(DateTime.parse(enddate));

    await FirebaseFirestore.instance
        .collection('tournaments')
        .doc(tourcontroller.email_controller.text)
        .update({
      'tournamentname': tournamentname,
      'tournamentlocation': tournamentlocation,
      'tournamentsport': tournamentsport,
      'tournamentimage': tournamentimage,
      'startdate': startDateTimestamp,
      'enddate': endDateTimestamp,
      'price': price,
    });
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
                                  _image!,
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
                    reusebletextfield(
                        controller: _updatetourname,
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
                        controller: _updatetourlocation,
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
                        controller: _updatetoursport,
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
                        controller: _updatetourstartdate,
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
                        controller: _updatetourenddate,
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
                        controller: _updatetourprice,
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
                      onTap: () async {
                        tourcontroller.checktourbottomsheet();

                        if (imageUrl.isEmpty) {
                          // Show an error message that the user needs to select an image first.
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Please select an image first."),
                            ),
                          );
                        } else if (tourcontroller.isformValide == true) {
                          try {
                            String tourname = _updatetourname.text.toString();
                            String location =
                                _updatetourlocation.text.toString();
                            String sport = _updatetoursport.text.toString();
                            String startdate =
                                _updatetourstartdate.text.toString();
                            String enddate = _updatetourenddate.text.toString();
                            String price = _updatetourprice.text.toString();
                            String image = imageUrl.toString();

                            if (_image != null) {
                              // Upload new image
                              String email = tourcontroller
                                  .email_controller.text
                                  .toString();
                              var refer = await FirebaseStorage.instance
                                  .ref("/MrSport$email")
                                  .child('tournamentimage')
                                  .putFile(_image!.absolute);
                              TaskSnapshot uploadTask = refer;
                              await Future.value(uploadTask);
                              image = await refer.ref.getDownloadURL();
                            }

                            edittournamentdetails(tourname, location, sport,
                                image, startdate, enddate, price);
                            updatetour();

                            Get.back();
                            Get.snackbar(
                              "Message",
                              "The tournament has been updated",
                              backgroundColor: Colors.green,
                              colorText: Colors.white,
                            );
                          } catch (e) {
                            Get.snackbar(
                              "Error",
                              "Error while updating tournament.",
                              backgroundColor: Colors.red,
                              colorText: Colors.white,
                            );
                          }
                        }
                      },
                      child: const Text("Save changes"),
                    )
                  ])))
            ]),
          )),
    );
  }
}
