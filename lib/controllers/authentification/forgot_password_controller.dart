import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordController {
  // Send password reset email
  Future<String?> sendPasswordResetEmail(String email) async {
    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      return null; // Success
    } catch (e) {
      return e.toString(); // Return the error message if it occurs
    }
  }
}
