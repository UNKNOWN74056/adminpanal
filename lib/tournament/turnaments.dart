import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:admin/widgets/savebutton.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import '../GETX/tournament.dart';
import '../widgets/textform.dart';

class turnaments extends StatefulWidget {
  const turnaments({super.key});

  @override
  State<turnaments> createState() => _turnamentsState();
}

//tournament getx controller
final tourcontroller = Get.put(tournamentgetx());

Future addtournmant(
    String tournamentname,
    String tournamentlocation,
    String tournamentsport,
    String tournamentimage,
    String startdate,
    String enddate,
    String price) async {
  await FirebaseFirestore.instance
      .collection('tournaments')
      .doc(tournamentname)
      .set({
    'tournamentname': tourcontroller.Tournament_Name.value,
    'tournamentlocation': tourcontroller.Tournament_Location.value,
    'tournamentsport': tourcontroller.Tournament_Sport.value,
    'tournamentimage': tournamentimage,
    'startdate': tourcontroller.start_date.value,
    'enddate': tourcontroller.end_date.value,
    'price': tourcontroller.price.value
  });
}

class _turnamentsState extends State<turnaments> {
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
        String format = DateFormat('yyyy-mm-dd').format(pickeddate);
        tourcontroller.start_date_controller.text = format.toString();
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
        String format = DateFormat('yyyy-mm-dd').format(pickeddate);
        tourcontroller.end_date_controller.text = format.toString();
      });
    }
  }

  Future addtour() async {
    var refer = await FirebaseStorage.instance
        .ref("/MrSport")
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
      //floating action button
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton(
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
                      child: Form(
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
                                controller:
                                    tourcontroller.Tournament_Name_controller,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboard: TextInputType.name,
                                validator: (Value) {
                                  return tourcontroller.validtourname(Value!);
                                },
                                icon:
                                    const Icon(FontAwesomeIcons.clipboardUser),
                                labelText: "Enter tournamanet name"),
                            const SizedBox(
                              height: 5,
                            ),
                            reusebletextfield(
                                controller: tourcontroller
                                    .Tournament_Location_controller,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                keyboard: TextInputType.name,
                                validator: (Value) {
                                  return tourcontroller
                                      .validtourlocation(Value!);
                                },
                                icon: const Icon(FontAwesomeIcons.locationDot),
                                labelText: "Enter tournament location"),
                            const SizedBox(
                              height: 5,
                            ),
                            reusebletextfield(
                                controller:
                                    tourcontroller.Tournament_Sport_controller,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                controller:
                                    tourcontroller.start_date_controller,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                // keyboard: TextInputType.datetime,
                                validator: (Value) {
                                  return tourcontroller.validstartdate(Value!);
                                },
                                icon: const Icon(Icons.schedule),
                                sufix: GestureDetector(
                                    onTap: () {
                                      add_start_date();
                                    },
                                    child:
                                        const Icon(FontAwesomeIcons.calendar)),
                                labelText: "Enter your start date"),
                            const SizedBox(
                              height: 5,
                            ),
                            reusebletextfield(
                                controller: tourcontroller.end_date_controller,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
                                //keyboard: TextInputType.datetime,
                                validator: (Value) {
                                  return tourcontroller.validenddate(Value!);
                                },
                                icon: const Icon(Icons.schedule),
                                sufix: GestureDetector(
                                    onTap: () {
                                      add_end_date();
                                    },
                                    child:
                                        const Icon(FontAwesomeIcons.calendar)),
                                labelText: "Enter your end date"),
                            const SizedBox(
                              height: 5,
                            ),
                            reusebletextfield(
                                controller: tourcontroller.price_controller,
                                autoValidateMode:
                                    AutovalidateMode.onUserInteraction,
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
                                  if (tourcontroller.isformValide == true) {
                                    addtour();
                                    Get.back();
                                    Get.snackbar('Message',
                                        'The tournament has been added');
                                  }
                                },
                                child: const Text("Add"))
                          ]))))));
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder(
          stream:
              FirebaseFirestore.instance.collection('tournaments').snapshots(),
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
                          onPressed: (context) {},
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
                                                "Tournament has been deleted");
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
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10, right: 10),
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
                                    padding: const EdgeInsets.only(left: 10),
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
                                              padding: const EdgeInsets.only(
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
                                              padding: const EdgeInsets.only(
                                                  left: 0),
                                              child: Text(
                                                  data['tournamentlocation']),
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
                                              color: Colors.red,
                                            ),
                                            const SizedBox(width: 5),
                                            const Text(
                                              "Start At:",
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            ),
                                            Text(data['startdate']),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.schedule,
                                          color: Colors.green,
                                        ),
                                        const Text(
                                          "End At: ",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        Text(data['enddate'])
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
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
                                          data['price'],
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
                    );
                  });
            }
            return const Center(
              child: CircularProgressIndicator(),
            );
          }),
    );
  }
}
