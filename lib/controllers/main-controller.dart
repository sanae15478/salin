import 'package:get/get.dart';

class MainController extends GetxController {
  bool isFirstEnter = false;
  String userName = "";
  String userEmail = "";
  String userAge = "";

  List tasks = [];

  updateMainStete(
      {bool? newFirstEnterStatus,
      String? newUserName,
      String? newUserEmail,
      String? newUserAge,
      List? newTasks}) {
    isFirstEnter = newFirstEnterStatus ?? isFirstEnter;
    userName = newUserName ?? userName;
    userEmail = newUserEmail ?? userEmail;
    userAge = newUserAge ?? userAge;
    tasks = newTasks ?? tasks;

    update();
  }
}
