import 'package:flutter/material.dart';

class reusebletextfield extends StatelessWidget {
  final controller;
  final validator;
  final maxline;
  final maxlength;
  final autoValidateMode;
  final keyboard;
  final icon;
  final sufix;
  final labelText;

  const reusebletextfield(
      {super.key,
      required this.controller,
      required this.autoValidateMode,
      this.keyboard,
      this.maxlength,
      this.maxline,
      this.sufix,
      this.validator,
      this.icon,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: validator,
      maxLines: maxline,
      maxLength: maxlength,
      autovalidateMode: autoValidateMode,
      style: const TextStyle(
        color: Colors.black,
      ),
      keyboardType: keyboard,
      textAlignVertical: TextAlignVertical.center,
      decoration: InputDecoration(
        filled: true,
        isDense: true,
        suffixIcon: sufix,
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
