import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/routes.dart';
import 'package:salin/controllers/main-controller.dart';
import 'package:salin/models/user/user-name.dart';

class LoadingButton extends StatefulWidget {
  final bool isDark;
  const LoadingButton({super.key, required this.isDark});

  @override
  _LoadingButtonState createState() => _LoadingButtonState();
}

class _LoadingButtonState extends State<LoadingButton> {
  late bool isLoading;
  late bool isSuccess;
  late double opacity;

  @override
  void initState() {
    super.initState();
    isLoading = false;
    isSuccess = false;
    opacity = 0.0;
    _showButtonWithDelay();
  }

  Future<void> _setName() async {
    setState(() {
      isLoading = true;
    });

    // Simulate network request
    bool success =
        await setUserName(userName: Get.find<MainController>().userName);

    setState(() {
      isLoading = false;
      isSuccess = success;
    });

    if (success) {
      Timer(const Duration(milliseconds: 1500), () {
        Navigator.pushReplacementNamed(context, home_route);
      });
    } else {
      Timer(const Duration(seconds: 2), () {
        setState(() {
          isSuccess = false; // Reset button to original state
        });
      });
    }
  }

  void _showButtonWithDelay() async {
    await Future.delayed(const Duration(milliseconds: 5555));
    setState(() {
      opacity = 1.0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final buttonColor = widget.isDark ? kBackgroundColor : kSecondaryColor;
    final successColor = Colors.greenAccent;
    final errorColor = Colors.redAccent;
    final valueColor = widget.isDark ? kDarkBackgroundColor : Colors.white;

    return AnimatedOpacity(
      opacity: opacity,
      duration: const Duration(milliseconds: 500),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: valueColor,
          backgroundColor: isSuccess
              ? successColor
              : isLoading
                  ? buttonColor.withOpacity(0.7)
                  : buttonColor,
          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : _setName,
        child: isLoading
            ? SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(
                  color: valueColor,
                  strokeWidth: 2,
                ),
              )
            : Text(
                isSuccess ? 'Success' : 'Continue',
                style: GoogleFonts.ubuntu(
                  color: valueColor,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}
