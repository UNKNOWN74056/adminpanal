import 'package:flutter/material.dart';

class reusebletextfield extends StatelessWidget {
  final controller;
  final validator;
  final maxline;
  final maxlength;
  final autoValidateMode;
  final keyboard;
  final icon;
  final labelText;
  final obscureText;
  final initialValue;
  final ontap;

  const reusebletextfield({
    super.key,
    this.controller,
    required this.autoValidateMode,
    required this.keyboard,
    this.maxlength,
    this.maxline = 1,
    required this.validator,
    required this.icon,
    this.initialValue,
    required this.labelText,
    this.obscureText = false,
    this.ontap
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      initialValue: controller != null ? null : initialValue,
      maxLines: maxline,
      maxLength: maxlength,
      autovalidateMode: autoValidateMode,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: keyboard,
      obscureText: obscureText,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        contentPadding: const EdgeInsets.symmetric(vertical: 22),
        prefixIcon: icon,
        labelText: labelText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        enabledBorder: OutlineInputBorder(
          // borderSide: const BorderSide(
          //   width: 4,
          //   //  color: Colors.lightGreen,
          // ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      cursorHeight: 23.0,
    );
  }
}
