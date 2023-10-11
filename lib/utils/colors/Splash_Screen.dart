import 'package:admin/utils/colors/Splah_Screen_Service.dart';
import 'package:flutter/material.dart';

class splashscreen extends StatefulWidget {
  const splashscreen({super.key});

  @override
  State<splashscreen> createState() => _splashscreenState();
}

class _splashscreenState extends State<splashscreen> {
  splashservice splash_screen = splashservice();

  @override
  void initState() {
    super.initState();

    splash_screen.islogin(context);
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SizedBox(
          width: double.infinity,
          height: double.infinity,
          child: Center(
            child: Center(
              child: CircularProgressIndicator(),
            ),
          )),
    );
  }
}
