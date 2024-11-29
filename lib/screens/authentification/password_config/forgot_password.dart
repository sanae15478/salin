import 'package:flutter/material.dart';

import '../../../constants/colors.dart';
import '../../../controllers/authentification/forgot_password_controller.dart';

class ForgotPasswordPage extends StatefulWidget {
  @override
  _ForgotPasswordPageState createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final TextEditingController _emailController = TextEditingController();
  final ForgotPasswordController _controller = ForgotPasswordController();
  bool _isLoading = false;
  String? _errorMessage;

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
      appBar: AppBar(title: Text("Forgot Password")),
      backgroundColor: kBackgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: 'Enter your email',
                border: OutlineInputBorder(),
                errorText: _errorMessage != null ? 'Please enter a valid email' : null,
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _resetPassword,
              child: Text('Send Password Reset Email'),
            ),
          ],
        ),
      ),
    );
  }
}
