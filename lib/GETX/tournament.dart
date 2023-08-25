import 'package:flutter/material.dart';
import 'package:get/get.dart';

class tournamentgetx extends GetxController {
  var Tournament_Name = "".obs;
  var Tournament_Location = "".obs;
  var Tournament_Sport = "".obs;
  var start_date = "".obs;
  var end_date = "".obs;
  var price = "".obs;
  bool isformValide = false;

  late TextEditingController Tournament_Name_controller,
      Tournament_Location_controller,
      Tournament_Sport_controller,
      start_date_controller,
      end_date_controller,
      price_controller;

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
  }

  final tourkeyForm = GlobalKey<FormState>();

  String? validtourname(String value) {
    if (value.isEmpty) {
      return "Please enter tournament name";
    }
    return null;
  }

  String? validtourlocation(String value) {
    if (value.isEmpty) {
      return "Please enter tournament location";
    }
    return null;
  }

  String? validtoursport(String value) {
    if (value.isEmpty) {
      return "Please enter tournament sport";
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
      return "Please enter accurate price";
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
      isformValide = true;
      // User those values to send our auth request ...
    }
  }
}
