import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Bttomsheetgetx extends GetxController {
  var clubname = "".obs;
  var email = "".obs;
  var location = "".obs;
  var sport = "".obs;
  var phone = "".obs;
  var rating = "".obs;
  bool isformValidated = false;

  late TextEditingController clubcontroller,
      emailcontroller,
      loactioncontroller,
      sportcontroller,
      phonecontroller,
      ratingcontroller;

  @override
  void onInit() {
    // TODO: implement onInit
    super.onInit();
    clubcontroller = TextEditingController();
    emailcontroller = TextEditingController();
    loactioncontroller = TextEditingController();
    sportcontroller = TextEditingController();
    phonecontroller = TextEditingController();
    ratingcontroller = TextEditingController();
  }

  final keyForm = GlobalKey<FormState>();

  String? validclubname(String value) {
    if (value.isEmpty) {
      return "Please enter club name";
    }
    return null;
  }

  String? validEmail(String value) {
    if (value.isEmpty) {
      return "Please enter Email";
    } else if (!value.contains("@gmail.com")) {
      return "Please enter correct email";
    }
    return null;
  }

  String? validlocation(String value) {
    if (value.isEmpty) {
      return "Please enter location";
    }
    return null;
  }

  String? validsport(String value) {
    if (value.isEmpty) {
      return "Please enter sport";
    }
    return null;
  }

  String? validphone(String value) {
    String regexPattern = r'(^(?:[+0][1-9])?[0-9]{10,12}$)';
    var regExp = RegExp(regexPattern);
    if (value.isEmpty) {
      return "Please enter phone";
    } else if (!value.contains("+")) {
      return "Please enter correct phone nmuber";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter valid mobile number";
    }
    return null;
  }

  String? validateRating(String rating) {
    if (rating.isEmpty) {
      return 'Please enter a rating';
    } else if (int.tryParse(rating) == null) {
      return 'Please enter a valid rating (1-5)';
    } else if (int.parse(rating) < 1 || int.parse(rating) > 5) {
      return 'Please enter a rating between 1 and 5';
    } else {
      return null;
    }
  }

  checkbottomsheet() {
    final isValid = keyForm.currentState!.validate();

    if (isValid) {
      keyForm.currentState!.save();
      clubname.value = clubcontroller.value.text;
      email.value = emailcontroller.value.text;
      location.value = loactioncontroller.value.text;
      sport.value = sportcontroller.value.text;
      phone.value = phonecontroller.value.text;
      rating.value = ratingcontroller.value.text;

      isformValidated = true;
    }
  }
}
