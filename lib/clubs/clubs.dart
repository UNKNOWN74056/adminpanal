import 'dart:io';
import 'package:admin/GETX/Bttomsheetgetx.dart';
import 'package:admin/clubs/clubdetails.dart';
import 'package:admin/widgets/savebutton.dart';
import 'package:admin/widgets/textform.dart';
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
  final controller = Get.put(Bttomsheetgetx());
  //update contorller
  final TextEditingController _updateclubname = TextEditingController();
  final TextEditingController _updateclubeamil = TextEditingController();
  final TextEditingController _updateclublocation = TextEditingController();
  final TextEditingController _updateclubsport = TextEditingController();
  final TextEditingController _updateclubphonecontect = TextEditingController();

  //function to dispose
  @override
  void dispose() {
    _updateclubeamil.dispose();
    _updateclublocation.dispose();
    _updateclubname.dispose();
    _updateclubphonecontect.dispose();
    _updateclubsport.dispose();
    super.dispose();
  }

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
                        key: controller.keyForm,
                        child: SingleChildScrollView(
                          child: Column(
                            children: [
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
                              //textfields with dailog
                              reusebletextfield(
                                  controller: controller.clubcontroller,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboard: TextInputType.name,
                                  validator: (Value) {
                                    return controller.validclubname(Value!);
                                  },
                                  icon: const Icon(
                                      FontAwesomeIcons.clipboardUser),
                                  labelText: "Enter club name"),
                              const SizedBox(
                                height: 5,
                              ),
                              reusebletextfield(
                                  controller: controller.emailcontroller,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboard: TextInputType.emailAddress,
                                  validator: (Value) {
                                    return controller.validEmail(Value!);
                                  },
                                  icon: const Icon(
                                      FontAwesomeIcons.solidEnvelope),
                                  labelText: "Enter email"),
                              const SizedBox(
                                height: 5,
                              ),
                              reusebletextfield(
                                  controller: controller.loactioncontroller,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboard: TextInputType.text,
                                  validator: (Value) {
                                    return controller.validlocation(Value!);
                                  },
                                  icon:
                                      const Icon(FontAwesomeIcons.locationDot),
                                  labelText: "Enter location"),
                              const SizedBox(
                                height: 5,
                              ),
                              reusebletextfield(
                                  controller: controller.sportcontroller,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboard: TextInputType.text,
                                  validator: (Value) {
                                    return controller.validsport(Value!);
                                  },
                                  icon:
                                      const Icon(FontAwesomeIcons.locationDot),
                                  labelText: "Enter sport"),
                              const SizedBox(
                                height: 5,
                              ),
                              reusebletextfield(
                                  controller: controller.phonecontroller,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboard: TextInputType.phone,
                                  validator: (Value) {
                                    return controller.validphone(Value!);
                                  },
                                  icon: const Icon(FontAwesomeIcons.phone),
                                  labelText: "+ code phone number"),
                              const SizedBox(
                                height: 15,
                              ),
                              reusebletextfield(
                                  controller: controller.ratingcontroller,
                                  autoValidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  keyboard: TextInputType.number,
                                  validator: (value) {
                                    return controller.validateRating(value);
                                  },
                                  icon: const Icon(FontAwesomeIcons.star),
                                  labelText: "Enter rating"),
                              const SizedBox(
                                height: 15,
                              ),

                              //button to add the clubs and save in database
                              savebutton(
                                  onTap: () {
                                    controller.checkbottomsheet();
                                    if (controller.isformValidated == true) {
                                      addclub();
                                      Get.back();
                                      Get.snackbar("Message",
                                          "The club has been added.");
                                    }
                                  },
                                  child: const Text("ADD"))
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
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
                          ActionPane(motion: ScrollMotion(), children: [
                        SlidableAction(
                          onPressed: (context) {
                            showModalBottomSheet(
                                isScrollControlled: true,
                                shape: const RoundedRectangleBorder(
                                    borderRadius: BorderRadius.vertical(
                                        top: Radius.circular(10))),
                                context: context,
                                builder: (context) => Container(
                                      margin: const EdgeInsets.all(20),
                                      padding: const EdgeInsets.all(8),
                                      child: Padding(
                                        padding: EdgeInsets.only(
                                            bottom: MediaQuery.of(context)
                                                .viewInsets
                                                .bottom),
                                        child: Form(
                                          key: controller.keyForm,
                                          child: SingleChildScrollView(
                                            child: Column(
                                              children: [
                                                const SizedBox(
                                                  height: 40,
                                                ),
                                                const Text(
                                                    "PLease fill these fields"),
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
                                                //textfields with dailog
                                                reusebletextfield(
                                                    controller: _updateclubname,
                                                    autoValidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    keyboard: TextInputType
                                                        .emailAddress,
                                                    validator: (Value) {
                                                      return controller
                                                          .validclubname(
                                                              Value!);
                                                    },
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .clipboardUser),
                                                    labelText:
                                                        "Enter club name"),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                reusebletextfield(
                                                    controller:
                                                        _updateclubeamil,
                                                    autoValidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    keyboard: TextInputType
                                                        .emailAddress,
                                                    validator: (Value) {
                                                      return controller
                                                          .validEmail(Value!);
                                                    },
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .solidEnvelope),
                                                    labelText: "Enter email"),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                reusebletextfield(
                                                    controller:
                                                        _updateclublocation,
                                                    autoValidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    keyboard:
                                                        TextInputType.text,
                                                    validator: (Value) {
                                                      return controller
                                                          .validlocation(
                                                              Value!);
                                                    },
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .locationDot),
                                                    labelText:
                                                        "Enter location"),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                reusebletextfield(
                                                    controller:
                                                        _updateclubsport,
                                                    autoValidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    keyboard:
                                                        TextInputType.text,
                                                    validator: (Value) {
                                                      return controller
                                                          .validsport(Value!);
                                                    },
                                                    icon: const Icon(
                                                        FontAwesomeIcons
                                                            .locationDot),
                                                    labelText: "Enter sport"),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                reusebletextfield(
                                                    controller:
                                                        _updateclubphonecontect,
                                                    autoValidateMode:
                                                        AutovalidateMode
                                                            .onUserInteraction,
                                                    keyboard:
                                                        TextInputType.phone,
                                                    validator: (Value) {
                                                      return controller
                                                          .validphone(Value!);
                                                    },
                                                    icon: const Icon(
                                                        FontAwesomeIcons.phone),
                                                    labelText:
                                                        "+ code phone number"),
                                                const SizedBox(
                                                  height: 15,
                                                ),
                                                //button to add the clubs and save in database
                                                savebutton(
                                                    onTap: () async {
                                                      controller
                                                          .checkbottomsheet();
                                                      if (controller
                                                              .isformValidated ==
                                                          true) {
                                                        var refer =
                                                            await FirebaseStorage
                                                                .instance
                                                                .ref("/MrSport")
                                                                .child('images')
                                                                .putFile(_image!
                                                                    .absolute);
                                                        TaskSnapshot
                                                            uploadTask = refer;
                                                        await Future.value(
                                                            uploadTask);
                                                        var newUrl = await refer
                                                            .ref
                                                            .getDownloadURL();
                                                        await data.reference
                                                            .update({
                                                          'Clubname':
                                                              _updateclubname
                                                                  .text
                                                                  .toString(),
                                                          'Email':
                                                              _updateclubeamil
                                                                  .text
                                                                  .toString(),
                                                          'Location':
                                                              _updateclublocation
                                                                  .text
                                                                  .toString(),
                                                          'Phone':
                                                              _updateclubphonecontect
                                                                  .text
                                                                  .toString(),
                                                          'sport':
                                                              _updateclubsport
                                                                  .text
                                                                  .toString(),
                                                          'Clubimage':
                                                              newUrl.toString()
                                                        });
                                                        Get.back();
                                                        Get.snackbar("Message",
                                                            "The change has been made.");
                                                      }
                                                    },
                                                    child: const Text("Save"))
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                    ));
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
                                                "Club has been deleted");
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
                                          NetworkImage(data['Clubimage']),
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
    );
  }
}
