import 'package:flutter/material.dart';

class FullScreenPhoto extends StatelessWidget {
  final String photo;

  const FullScreenPhoto({Key? key, required this.photo}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GestureDetector(
        onTap: () {
          // Navigate back to previous screen on tap
          Navigator.of(context).pop();
        },
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(photo),
              fit: BoxFit.cover,
            ),
          ),
        ),
      ),
    );
  }
}
