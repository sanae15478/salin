import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/screens/new-task/animations.dart';

class NewTaskCloseButton extends StatelessWidget {
  final Duration _animationDuration = const Duration(milliseconds: 500);
  late bool _isDark;

  NewTaskCloseButton({super.key});
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;
    return GetBuilder<NewTaskAnimationsController>(builder: (_) {
      return AnimatedOpacity(
        opacity: _.closeButtonOpacity,
        duration: _animationDuration,
        child: Padding(
          padding: const EdgeInsets.only(top: 20, right: 30),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Container(
                child: GestureDetector(
                  child: Icon(FontAwesomeIcons.timesCircle,
                      size: 50,
                      color: _isDark
                          ? kBackgroundColor
                          : kSecondaryColor.withOpacity(0.75)),
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
