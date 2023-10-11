import 'package:admin/model/videomodel.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class FetchVideoFirebase extends GetxController {
  RxList videolist = <video>[].obs;
  @override
  void onInit() {
    super.onInit();
    // Call Getallvideos() function when the controller is initialized
    Getallvideos();
  }

  // Function to refresh videolist
  Future<void> refresh_videos() async {
    await Getallvideos();
  }

  // get all the data of users from firebase
  Getallvideos() async {
    videolist.clear();
    await FirebaseFirestore.instance
        .collection("videos")
        .get()
        .then((QuerySnapshot snapshot) {
      for (var f in snapshot.docs) {
        videolist.add(video(
          id: f['id'],
          videolink: f['videourl'],
          email: f['email'],
        ));
      }
    });
  }
}
