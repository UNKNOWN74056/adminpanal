import 'package:admin/model/clubmodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class Getclubdata extends GetxController {
  RxList clublist = <Clubs>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Call Getallvideos() function when the controller is initialized
    Getclubdatafirebase();
  }

  // Function to refresh videolist
  Future<void> refresh_videos() async {
    await Getclubdatafirebase();
  }

  //get data for clubs from firebase
  Getclubdatafirebase() async {
    clublist.clear();
    await FirebaseFirestore.instance
        .collection("clubs")
        .get()
        .then((QuerySnapshot snapshot) {
      snapshot.docs.forEach((c) {
        clublist.add(Clubs(
          clubimage: c['Clubimage'],
          clubname: c['Clubname'],
          email: c['Email'],
          location: c['Location'],
          phonenumber: c['Phone'],
          rating: c['rating'],
          sport: c['sport'],
        ));
      });
    });
  }
}
