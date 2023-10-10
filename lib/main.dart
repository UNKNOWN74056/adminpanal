import 'package:admin/GETX/Total_Tournmaent.dart';
import 'package:admin/GETX/Total_Tournmaents.dart';
import 'package:admin/admin.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';

Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
  Get.put(UserController()); // Initialize the UserController here.
  Get.put(TournamentController());
}

class MyApp extends StatelessWidget {
  final Future<FirebaseApp> _initailization = Firebase.initializeApp();

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initailization,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          Get.snackbar("Error", "Somthing went wrong!");
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        return GetMaterialApp(
            title: 'Flutter Demo',
            theme: ThemeData.light().copyWith(useMaterial3: true),
            debugShowCheckedModeBanner: false,
            home: const MyAdminPage());
      },
    );
  }
}
