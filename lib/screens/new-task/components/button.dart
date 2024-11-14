import 'dart:async';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomLoadingButton extends StatefulWidget {
  const CustomLoadingButton({super.key});

  @override
  _CustomLoadingButtonState createState() => _CustomLoadingButtonState();
}

class _CustomLoadingButtonState extends State<CustomLoadingButton> {
  bool isLoading = false;

  void _startLoading() {
    setState(() {
      isLoading = true;
    });

    // Simulate a network call or task
    Timer(const Duration(seconds: 2), () {
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final Brightness brightnessValue =
        MediaQuery.of(context).platformBrightness;
    final bool isDark = brightnessValue == Brightness.dark;

    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: isDark ? Colors.white : Colors.blueAccent,
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      onPressed: isLoading ? null : _startLoading,
      child: isLoading
          ? SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                color: isDark ? Colors.black : Colors.white,
                strokeWidth: 3,
              ),
            )
          : Row(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 10),
                Text(
                  'New Task',
                  style: GoogleFonts.ubuntu(
                    color: isDark ? Colors.black : Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(width: 10),
                Icon(
                  FontAwesomeIcons.chevronUp,
                  size: 20,
                  color: isDark ? Colors.black : Colors.white,
                ),
              ],
            ),
    );
  }
}
