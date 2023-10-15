import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class clubGetx extends GetxController {
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
      return "Please enter a club name";
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

  String? validlocation(String value) {
    if (value.isEmpty) {
      return "Please enter a city name";
    } else if (!_isTextOnly(value)) {
      return "Please enter a valid name with only letters";
    }
    return null;
  }

  String? validsport(String value) {
    if (value.isEmpty) {
      return "Please enter a sport name";
    } else if (!_isTextOnly(value)) {
      return "Please enter a valid name with only letters";
    }
    return null;
  }

  String? validphone(String value) {
    String regexPattern = r'^(?:\+92)?[0-9]{9}$';
    var regExp = RegExp(regexPattern);

    if (value.isEmpty) {
      return "Please enter a phone number";
    } else if (!value.startsWith("+92")) {
      return "Please enter the country code +92";
    } else if (!regExp.hasMatch(value)) {
      return "Please enter a valid mobile number";
    }

    return null;
  }

  String? validateRating(String rating) {
    if (rating.isEmpty) {
      return 'Please enter a rating';
    } else if (int.tryParse(rating) == null) {
      return 'Please enter a valid rating (0-5)';
    } else if (int.parse(rating) < 0 || int.parse(rating) > 5) {
      return 'Please enter a rating between 0 and 5';
    } else if (!RegExp(r'^[0-5]$').hasMatch(rating)) {
      return 'Please enter a valid rating (0-5)';
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

  @override
  void dispose() {
    clubcontroller.dispose();
    loactioncontroller.dispose();
    phonecontroller.dispose();
    ratingcontroller.dispose();
    emailcontroller.dispose();
    sportcontroller.dispose();
    super.dispose();
  }
}
