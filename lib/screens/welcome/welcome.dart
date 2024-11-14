import 'package:flutter/material.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/types.dart';
import 'package:salin/models/set-system-overlay-style.dart';
import 'package:salin/screens/welcome/components/button.dart';
import 'package:salin/screens/welcome/components/name.dart';
import 'package:salin/screens/welcome/components/text.dart';

class WelcomeScreen extends StatelessWidget {
  late bool _isDark;

  WelcomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;
    _isDark
        ? setSystemUIOverlayStyle(
            systemUIOverlayStyle: SystemUIOverlayStyle.DARK)
        : setSystemUIOverlayStyle(
            systemUIOverlayStyle: SystemUIOverlayStyle.LIGHT);
    return Scaffold(
        backgroundColor: _isDark ? kDarkBackgroundColor : kBackgroundColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(),
            const SizedBox(),
            Center(child: WelcomeText(isDark: _isDark)),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            Center(
              child: WelcomeName(isDark: _isDark),
            ),
            const SizedBox(),
            const SizedBox(),
            const SizedBox(),
            LoadingButton(isDark: _isDark),
            const SizedBox(),
            const SizedBox(),
          ],
        ));
  }
}
