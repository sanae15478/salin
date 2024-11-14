import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/types.dart';
import 'package:salin/models/set-system-overlay-style.dart';
import 'package:salin/screens/home/animations.dart';
import 'package:salin/controllers/home/home-controller.dart';
import 'package:salin/screens/home/components/drawer/drawer.dart';
import 'package:salin/screens/home/components/floating-button.dart';
import 'package:salin/screens/home/components/navbar.dart';
import 'package:salin/screens/home/components/tasks/tasks.dart';
import 'package:salin/screens/home/components/title-text.dart';

class HomeScreen extends StatelessWidget {
  final HomeController homeController = Get.put(HomeController());
  final HomeAnimationsController homeAnimationsController =
      Get.put(HomeAnimationsController());
  final int num = 0;
  late bool _isDark;

  HomeScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    _isDark = brightnessValue == Brightness.dark;
    _isDark
        ? setSystemUIOverlayStyle(
            systemUIOverlayStyle: SystemUIOverlayStyle.BLUE_DARK)
        : setSystemUIOverlayStyle(
            systemUIOverlayStyle: SystemUIOverlayStyle.LIGHT);

    homeController.advancedDrawerController.addListener(() {
      Get.find<HomeController>().changeDrawerStatus();
      if (Get.find<HomeController>().drawerStatus == DrawerStatus.OPEN) {
        _isDark
            ? setSystemUIOverlayStyle(
                systemUIOverlayStyle: SystemUIOverlayStyle.DARK)
            : setSystemUIOverlayStyle(
                systemUIOverlayStyle: SystemUIOverlayStyle.BLUE);
      } else if (Get.find<HomeController>().drawerStatus ==
          DrawerStatus.CLOSE) {
        _isDark
            ? setSystemUIOverlayStyle(
                systemUIOverlayStyle: SystemUIOverlayStyle.BLUE_DARK)
            : setSystemUIOverlayStyle(
                systemUIOverlayStyle: SystemUIOverlayStyle.LIGHT);
      }
    });

    startHomeAnimations();

    return GetBuilder<HomeController>(
      builder: (_) {
        return AdvancedDrawer(
          backdropColor: _isDark ? kDarkBackgroundColor : kSecondaryColor,
          controller: homeController.advancedDrawerController,
          animationCurve: Curves.easeInOut,
          animationDuration: const Duration(milliseconds: 300),
          animateChildDecoration: true,
          rtlOpening: false,
          openRatio: 0.66,
          disabledGestures: false,
          childDecoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(50)),
          ),
          drawer: HomeDrawer(),
          child: Scaffold(
            backgroundColor: _isDark ? kDarkBackgroundColor2 : kBackgroundColor,
            body: SafeArea(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Column(
                  children: [
                    HomeNavbar(),
                    HomeTitleText(),
                    HomeTasks(), // Ensures tasks display in the home screen
                  ],
                ),
              ),
            ),
            floatingActionButton: Padding(
              padding: const EdgeInsets.only(right: 15, bottom: 25),
              child: HomeFloatingButton(),
            ),
          ),
        );
      },
    );
  }
}
