import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/routes.dart';
import 'package:salin/screens/home/animations.dart';

class HomeFloatingButton extends StatelessWidget {
  final Duration _duration = const Duration(milliseconds: 500);
  late bool _isDark;

  HomeFloatingButton({super.key});
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;
    return GetBuilder<HomeAnimationsController>(
      builder: (_) {
        return AnimatedOpacity(
          opacity: _.floatingButtonOpacity,
          duration: _duration,
          child: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, newtask_route);
            },
            backgroundColor: _isDark ? kBackgroundColor : kSecondaryColor,
            highlightElevation: 3,
            child: Icon(
              Icons.add_rounded,
              size: _isDark ? 33 : 30,
              color: _isDark ? kDarkPrimaryColor : Colors.white,
            ),
          ),
        );
      },
    );
  }
}
