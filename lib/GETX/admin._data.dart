import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AdminController extends GetxController {
  final RxList<AdminData> adminDataList = <AdminData>[].obs;

  @override
  void onInit() {
    super.onInit();
    adminDataList.bindStream(loadAdminData());
  }

  Stream<List<AdminData>> loadAdminData() {
    return FirebaseFirestore.instance.collection('admin').snapshots().map(
        (snapshot) =>
            snapshot.docs.map((doc) => AdminData.fromDocument(doc)).toList());
  }
}

class AdminData {
  final String email;
  final String username;

  AdminData({required this.email, required this.username});

  factory AdminData.fromDocument(QueryDocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AdminData(
      email: data['email'] ?? '',
      username: data['username'] ?? '',
    );
  }
}
