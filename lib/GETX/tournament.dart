import 'package:flutter/material.dart';
import 'package:get/get.dart';

class tournamentgetx extends GetxController {
  var Tournament_Name = "".obs;
  var Tournament_Location = "".obs;
  var Tournament_Sport = "".obs;
  var start_date = "".obs;
  var end_date = "".obs;
  var price = "".obs;
  var email = "".obs;
  int fee = 0;
  bool isformValide = false;

  late TextEditingController Tournament_Name_controller,
      Tournament_Location_controller,
      Tournament_Sport_controller,
      start_date_controller,
      end_date_controller,
      price_controller,
      email_controller,
      fee_controller;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    Tournament_Name_controller = TextEditingController();
    Tournament_Location_controller = TextEditingController();
    Tournament_Sport_controller = TextEditingController();
    start_date_controller = TextEditingController();
    end_date_controller = TextEditingController();
    price_controller = TextEditingController();
    email_controller = TextEditingController();
    fee_controller = TextEditingController();
  }

  final tourkeyForm = GlobalKey<FormState>();

  String? validtourname(String value) {
    if (value.isEmpty) {
      return "Please enter a tournament name";
    } else if (!_isTextOnly(value)) {
      return "Please enter a valid name with only letters";
    }
    return null;
  }

  bool _isTextOnly(String value) {
    // Use a regular expression to match only letters (uppercase and lowercase) and spaces
    RegExp regex = RegExp(r'^[a-zA-Z\s]+$');
    return regex.hasMatch(value);
  }

  String? validtourlocation(String value) {
    if (value.isEmpty) {
      return "Please enter city name";
    } else if (!_isTextOnly(value)) {
      return "Please enter a valid name with only letters";
    }
    return null;
  }

  String? validtoursport(String value) {
    if (value.isEmpty) {
      return "Please enter sport name";
    } else if (!_isTextOnly(value)) {
      return "Please enter a valid name with only letters";
    }
    return null;
  }

  String? validstartdate(String value) {
    if (value.isEmpty) {
      return "Please enter start date";
    }
    return null;
  }

  String? validenddate(String value) {
    if (value.isEmpty) {
      return "Please enter end date";
    }
    return null;
  }

  String? valideprice(String value) {
    if (value.isEmpty) {
      return "Please enter price";
    } else if (!RegExp(r'^\d+$').hasMatch(value)) {
      return "Please enter a valid price";
    }
    return null;
  }

  String? validEmail(String value) {
    if (value.isEmpty) {
      return "Please enter an email";
    } else if (!value.contains("@gmail.com") &&
        !value.contains("@yahoo.com") &&
        !value.contains("@cusite.com") &&
        !value.contains("@hotmail.com")) {
      return "Please enter a valid email";
    } else if (value.endsWith("@gmail.com") ||
        value.endsWith("@yahoo.com") ||
        value.endsWith("@cusite.com") ||
        value.endsWith("@hotmail.com")) {
      if (value.startsWith("@")) {
        return "Please enter a valid email with a username";
      }
    }
    return null;
  }

  checktourbottomsheet() {
    if (tourkeyForm.currentState!.validate()) {
      final isValid = tourkeyForm.currentState!.validate();

      if (!isValid) {
        return null;
      }
      tourkeyForm.currentState!.save();
      Tournament_Name.value = Tournament_Name_controller.value.text;
      Tournament_Location.value = Tournament_Location_controller.value.text;
      Tournament_Sport.value = Tournament_Sport_controller.value.text;
      start_date.value = start_date_controller.value.text;
      end_date.value = end_date_controller.value.text;
      price.value = price_controller.value.text;
      email.value = email_controller.value.text;
       fee = int.tryParse(fee_controller.value.text) ?? 0;
      isformValide = true;
      // User those values to send our auth request ...
    }
  }

  @override
  void dispose() {
    Tournament_Name_controller.dispose();
    Tournament_Location_controller.dispose();
    Tournament_Sport_controller.dispose();
    start_date_controller.dispose();
    end_date_controller.dispose();
    price_controller.dispose();
    email_controller.dispose();
    fee_controller.dispose();
    super.dispose();
  }
}
