import 'package:admin/GETX/Total_Transection.dart';
import 'package:admin/utils/colors/App_Colors.dart';
import 'package:admin/view/user/Show_User.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shimmer/shimmer.dart';

class ShimmerWidget extends StatefulWidget {
  const ShimmerWidget({super.key});

  @override
  State<ShimmerWidget> createState() => _ShimmerWidgetState();
}

class _ShimmerWidgetState extends State<ShimmerWidget> {
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
    // totalTransactionController
    //     .fetchRegistrationRequests(); // Call the data-fetching function here
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return ListView.builder(
        itemCount: 3,
        shrinkWrap: true,
        itemBuilder: (context, i) {
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Center(
              child: Shimmer.fromColors(
                baseColor: const Color.fromARGB(255, 207, 203, 203),
                highlightColor: const Color.fromARGB(255, 191, 179, 179),
                child: Container(
                  height: 130,
                  width: 300,
                  decoration: BoxDecoration(
                    color: AppColors.backgroundColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ),
            ),
          );
        },
      );
    } else {
      return Center(
        child: Column(
          children: [
            StreamBuilder(
              stream:
                  FirebaseFirestore.instance.collection('users').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(
                    child: Text('Error: ${snapshot.error}'),
                  );
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }

                if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                  return const Center(
                    child: Text('No users found.'),
                  );
                }

                final userCount = snapshot.data!.docs.length;

                return GestureDetector(
                  onTap: () {
                    Get.to(const Show_User());
                  },
                  child: Container(
                    width: 300,
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors.backgroundColor,
                      borderRadius:
                          BorderRadius.circular(20), // Rounded corners
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.person,
                            size: 50,
                            color: AppColors.successColor,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Total users: $userCount",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
            const SizedBox(
              height: 20,
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('tournaments')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  int count = snapshot.data!.docs.length;

                  return Container(
                    width: 300,
                    height: 130,
                    decoration: BoxDecoration(
                      color: AppColors
                          .backgroundColor, // Replace with your desired color
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Icon(
                            Icons.sports_soccer,
                            size: 50,
                            color: Color.fromARGB(255, 255, 64, 198),
                          ),
                          const SizedBox(width: 10),
                          Text(
                            "Total tournaments: $count",
                            style: const TextStyle(fontSize: 20),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Text("Error: ${snapshot.error}");
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),
            const SizedBox(
              height: 20,
            ),
            TotalTransactionController().getTotalTransactionStreamBuilder(),
          ],
        ),
      );
    }
  }
}
