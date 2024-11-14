import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/routes.dart';
import 'package:salin/controllers/main-controller.dart';
import 'package:salin/models/set-system-overlay-style.dart';
import 'package:salin/models/tasks.dart';
import 'package:salin/constants/types.dart';
import 'package:salin/models/user/user-email.dart';
import 'package:salin/models/user/user-name.dart';
import 'package:salin/screens/loading/animations.dart';
import 'package:salin/screens/loading/components/logo.dart';
import 'package:salin/screens/loading/components/spinkit.dart';

class LoadingScreen extends StatefulWidget {
  const LoadingScreen({super.key});

  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {
  LoadingAnimationsController loadingAnimationsController =
      Get.put(LoadingAnimationsController());
  late String nextRoute;
  late bool isFirstEnter;
  late bool _isDark;
  @override
  void initState() {
    super.initState();
    nextRoute = home_route;
    isFirstEnter = false;
    startLoadingAnimations();
    load();
  }

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
        body: Padding(
            padding: const EdgeInsets.only(left: 50, right: 45),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                const SizedBox(),
                LoadingLogo(
                  isDark: _isDark,
                ),
                const SizedBox(),
                LoadingSpinkit(
                  isDark: _isDark,
                ),
              ],
            )));
  }

  load() async {
    await check();
    pass();
  }

  check() async {
    await checkUserName().then((response) {
      Get.find<MainController>().updateMainStete(
        newFirstEnterStatus: !response,
      );
      setState(() {
        isFirstEnter = !response;
        if (isFirstEnter) {
          nextRoute = welcome_route;
        } else {
          getTasks();
          getUserName().then((response) {
            Get.find<MainController>().updateMainStete(
              newUserName: response,
            );
          });
          getUserEmail();

          nextRoute = home_route;
        }
      });
    });
  }

  pass() async {
    await Future.delayed(loadingAnimationsController.allAnimationTimes);
    Navigator.pushReplacementNamed(context, nextRoute);
  }
}
