import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:salin/controllers/main-controller.dart';

Future<bool> checkUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  bool userNameStatus = prefs.getString('user-email') != null ? true : false;

  return userNameStatus;
}

Future<bool> setUserEmail({required String userEmail}) async {
  // Await the result of EmailValidation to make sure it finishes before continuing
  bool isValid = await EmailValidation(email: userEmail);

  if (isValid) {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('user-email', userEmail);
    getUserEmail();
    return true;
  } else {
    return false;
  }
}

Future<String?> getUserEmail() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  String? userEmail = prefs.getString('user-email');
  Get.find<MainController>().updateMainStete(newUserEmail: userEmail);

  return userEmail;
}

// ignore: non_constant_identifier_names
Future<bool> EmailValidation({required String email}) async {
  RegExp regex = RegExp(
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');
  if (!regex.hasMatch(email)) {
    return false;
  } else {
    return true;
  }
}
