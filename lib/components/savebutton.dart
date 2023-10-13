import 'package:admin/utils/colors.dart';
import 'package:flutter/material.dart';

class savebutton extends StatelessWidget {
  final Function()? onTap;
  final Widget child;

  const savebutton({super.key, required this.onTap, required this.child});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 70),
        decoration: BoxDecoration(
            color: AppColors.black, borderRadius: BorderRadius.circular(8)),
        child: Center(
          child: Center(
            child: DefaultTextStyle.merge(
              style: const TextStyle(
                  color: Colors.white), // Set the text color to white
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
