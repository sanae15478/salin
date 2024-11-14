import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/task-colors.dart';
import 'package:salin/constants/types.dart';
import 'package:salin/models/set-system-overlay-style.dart';
import 'package:salin/screens/new-task/animations.dart';
import 'package:salin/screens/new-task/components/button.dart';
import 'package:salin/screens/new-task/components/close.dart';
import 'package:salin/screens/new-task/components/setup.dart';
import 'package:salin/controllers/new-task/newtask-controller.dart';

class NewTaskScreen extends StatelessWidget {
  final NewTaskController newTaskController = Get.put(NewTaskController());
  final NewTaskAnimationsController newTaskAnimationsController = Get.put(
    NewTaskAnimationsController(),
  );

  NewTaskScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    final bool _isDark = brightnessValue == Brightness.dark;

    // Set system overlay style based on theme
    _isDark
        ? setSystemUIOverlayStyle(
            systemUIOverlayStyle: SystemUIOverlayStyle.BLUE_DARK)
        : setSystemUIOverlayStyle(
            systemUIOverlayStyle: SystemUIOverlayStyle.LIGHT);

    // Start animations for the screen
    startAnimations();

    return WillPopScope(
      onWillPop: () async {
        return await closePage(context);
      },
      child: Scaffold(
        backgroundColor: _isDark ? kDarkBackgroundColor2 : Colors.white,
        body: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              NewTaskCloseButton(),
              NewTaskSetup(),
              CustomLoadingButton(), // Replace with your CustomLoadingButton
            ],
          ),
        ),
      ),
    );
  }

  Future<bool> closePage(BuildContext context) async {
    await newTaskController.updateNewTask(
        newColor: color1, newColorNum: 0, newText: "");
    await newTaskAnimationsController.updateAnimations(
      newAddButtonOpacity: 0,
      newBox1Opacity: 0,
      newBox2Opacity: 0,
      newCloseButtonOpacity: 0,
      newTextFieldOpacity: 0,
    );
    Navigator.pop(context); // Go back to the previous screen
    return true; // Indicate that the pop action can be performed
  }
}
