import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/controllers/authentification/authcontroller.dart';

class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final AuthController authController = Get.put(AuthController());

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isPasswordVisible = false;
  bool _isRememberMeChecked = false;

  late AnimationController _controller;
  late Animation<double> _logoAnimation;
  late Animation<double> _fieldAnimation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController
    _controller = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _fieldAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward(); // Start animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
                horizontal: 24.0), // More padding for a cleaner look
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo with animation
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Transform.translate(
                      offset: Offset(
                          0,
                          50 *
                              (1 -
                                  _logoAnimation
                                      .value)), // Slight vertical animation
                      child: Image.asset(
                        'assets/images/logosalin.png',
                        height:
                            200, // Adjust the height for a more balanced design
                        width: 200, // Adjust the width for a better proportion
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email Field with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextField(
                      controller: emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.openSans(
                          color: Colors.grey[600], // Softer label color
                        ),
                        hintText: "Enter your email",
                        hintStyle: GoogleFonts.openSans(
                          color: Colors.grey[400], // Softer hint text color
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18,
                            horizontal: 20), // Adjust content padding
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Password Field with Eye Icon and fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextField(
                      controller: passwordController,
                      decoration: InputDecoration(
                        labelText: "Password",
                        labelStyle: GoogleFonts.openSans(
                          color: Colors.grey[600],
                        ),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey[600], // Eye icon color
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 18, horizontal: 20),
                      ),
                      obscureText: !_isPasswordVisible,
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Remember Me Row with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: Row(
                      children: [
                        Checkbox(
                          value: _isRememberMeChecked,
                          onChanged: (bool? value) {
                            setState(() {
                              _isRememberMeChecked = value!;
                            });
                          },
                          activeColor: kPrimaryColor,
                        ),
                        Text(
                          "Remember Me",
                          style: GoogleFonts.openSans(
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign In Button with scale animation
                  ScaleTransition(
                    scale: _fieldAnimation,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor:
                            kPrimaryColor, // Text color when the button is pressed
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(
                            vertical: 16, horizontal: 32),
                        elevation: 5, // Subtle shadow to elevate the button
                      ),
                      onPressed: () => authController.signInWithEmailPassword(
                        emailController.text.trim(),
                        passwordController.text.trim(),
                        context,
                      ),
                      child: Text(
                        "Sign in",
                        style: GoogleFonts.roboto(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w600, // Bold for better emphasis
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Forgot Password Text Button with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextButton(
                      onPressed: () {
                        // Handle Forgot Password logic here
                      },
                      child: Text(
                        "Forgot Password?",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: kPrimaryColor, // Matching the primary color
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Sign Up Text Button with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextButton(
                      onPressed: () {
                        // Handle Sign Up navigation
                      },
                      child: Text(
                        "Don't have an account? Sign Up",
                        style: GoogleFonts.roboto(
                          fontSize: 14,
                          color: Colors.blue[700], // Blue color for emphasis
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
