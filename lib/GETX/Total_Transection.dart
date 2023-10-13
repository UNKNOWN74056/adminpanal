import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class TotalTransactionController extends GetxController {
  final RxList<DocumentSnapshot> registrationRequests =
      <DocumentSnapshot>[].obs;
  final RxInt totalFee = 0.obs;

  StreamBuilder<int> getTotalTransactionStreamBuilder() {
    return StreamBuilder<int>(
      stream: FirebaseFirestore.instance
          .collection('registrationRequests')
          .snapshots()
          .asyncMap((event) async {
        int totalFeeValue = 0;

        for (var request in event.docs) {
          final data = request.data();
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

        // Update the totalFee with the new value
        totalFee(totalFeeValue);

        return totalFeeValue; // Return the total fee
      }),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text("Error: ${snapshot.error}");
        } else {
          final totalTransactionFee = snapshot.data ?? 0;
          return Container(
            height: 130,
            width: 300,
            decoration: BoxDecoration(
              color: AppColors.backgroundColor, // Replace with your color
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Icon(
                    Icons.attach_money,
                    size: 50,
                    color: AppColors.successColor,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    "Total Transaction: $totalTransactionFee",
                    style: const TextStyle(fontSize: 20),
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }
}
