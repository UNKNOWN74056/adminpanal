import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Total_Transection extends GetxController {
  RxList<DocumentSnapshot> registrationRequests = <DocumentSnapshot>[].obs;
  RxInt totalFee = 0.obs;

  void fetchRegistrationRequests() {
    FirebaseFirestore.instance
        .collection('registrationRequests')
        .snapshots()
        .listen((event) {
      registrationRequests.assignAll(event.docs);
    });
  }

  Future<int> calculateTotalFee() async {
    int totalFeeValue = 0;

    for (var request in registrationRequests) {
      final data = request.data() as Map<String, dynamic>?;
      if (data != null) {
        final approve = data['isApproved'] as bool?;
        final sportEventName = data['sportevent'] as String?;

        if (approve == true) {
          final tournamentQuery = await FirebaseFirestore.instance
              .collection('tournaments')
              .where('tournamentname', isEqualTo: sportEventName)
              .get();

          if (tournamentQuery.docs.isNotEmpty) {
            final tournamentData = tournamentQuery.docs.first.data();
            int fee = tournamentData['fee'] ?? 0;
            totalFeeValue += fee;
          }
        }
      }
    }

    // Update the totalFee with the new value
    totalFee(totalFeeValue);

    return totalFeeValue; // Return the total fee
  }
}
