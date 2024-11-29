import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/models/tasks.dart';
import 'package:salin/screens/home/animations.dart';
import 'package:salin/screens/home/components/tasks/items.dart';

class HomeTasks extends StatelessWidget {
  final Duration _animationDuration = const Duration(milliseconds: 500);
  late bool _isDark;

  HomeTasks({super.key});
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;
    return GetBuilder<HomeAnimationsController>(builder: (_) {
      return Padding(
        padding: const EdgeInsets.only(top: 50.0),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 25.0),
                  child: AnimatedOpacity(
                    duration: _animationDuration,
                    opacity: _.tasksTitleOpacity,
                    child: Text(
                      "Groceries",
                      style: TextStyle(
                          fontSize: 12.5,
                          fontWeight: FontWeight.bold,
                          color: _isDark
                              ? kBackgroundColor.withOpacity(0.5)
                              : Colors.black.withOpacity(0.3)),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: AnimatedOpacity(
                      duration: _animationDuration,
                      opacity: _.tasksTitleOpacity,
                      child: IconButton(
                          icon: Icon(FontAwesomeIcons.checkDouble,
                              size: 22.5,
                              color: _isDark
                                  ? kBackgroundColor.withOpacity(0.5)
                                  : Colors.black.withOpacity(0.3)),
                          onPressed: () async {
                            await Future.delayed(
                                const Duration(milliseconds: 111));
                            doneAllTasks();
                          })),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            HomeTasksItems()
          ],
        ),
      );
    });
  }
}
