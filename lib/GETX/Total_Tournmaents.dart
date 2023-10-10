import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserController extends GetxController {
  final RxInt totalUsers = 0.obs;
  late Stream<QuerySnapshot> userStream;

  UserController() {
    initStream();
  }

  void initStream() {
    userStream = FirebaseFirestore.instance.collection('users').snapshots();
  }
}
