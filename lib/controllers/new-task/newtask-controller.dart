import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/task-colors.dart';

class NewTaskController extends GetxController {
  String text = "";
  Color color = color1;
  int colorNum = 0;

  updateNewTask({String? newText, Color? newColor, int? newColorNum}) {
    text = newText ?? text;
    color = newColor ?? color;
    colorNum = newColorNum ?? colorNum;

    update();
  }
}
