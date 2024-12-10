import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/controllers/authentification/forgot_password_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> with SingleTickerProviderStateMixin {
  final TextEditingController _emailController = TextEditingController();
  final ForgotPasswordController _controller = ForgotPasswordController();
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _controllerAnimation;
  late Animation<double> _fieldAnimation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _controllerAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeInOut),
    );

    _fieldAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeInOut),
    );

    _controllerAnimation.forward();
  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    super.dispose();
  }

  // Call the controller to send the password reset email
  void _resetPassword() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Use the controller to handle password reset logic
    String? error = await _controller.sendPasswordResetEmail(_emailController.text);

    setState(() {
      _isLoading = false;
      _errorMessage = error;
    });

    if (error == null) {
      // Success message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text("Password reset email sent!"),
      ));
      Navigator.pop(context); // Optionally, go back after sending the email
    } else {
      // Error message
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(_errorMessage ?? "An error occurred!"),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundColor,
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo with animation (optional)
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - _logoAnimation.value)),
                      child: Image.asset(
                        'assets/images/avatar.png',
                        height: 200,
                        width: 200,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),

                  // Email field with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Email",
                        labelStyle: GoogleFonts.openSans(color: Colors.grey[600]),
                        hintText: "Enter your email",
                        hintStyle: GoogleFonts.openSans(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        errorText: _errorMessage != null ? 'Please enter a valid email' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Loading indicator or Reset button with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: _resetPassword,
                      child: Text(
                        'Send Password Reset Email',
                        style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(

                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
                        elevation: 5,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Back to login button with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextButton(
                      onPressed: () {
                        Navigator.pop(context); // Navigate back to the login screen
                      },
                      child: Text(
                        "Back to Login",
                        style: GoogleFonts.roboto(fontSize: 14, color: Colors.teal),
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
