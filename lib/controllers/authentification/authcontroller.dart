import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/material.dart';
import 'package:salin/screens/grocery/grocerylist.dart';

class AuthController {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Sign in with Google
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      final GoogleSignIn googleSignIn = GoogleSignIn();
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();

      if (googleUser != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleUser.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );
        /*
        if (!userCredential.user!.emailVerified) {
          Get.offNamed('/verify-email'); // Rediriger vers l'écran de vérification
        } else {
          Get.offNamed('/grocery'); // Rediriger vers l'écran des courses
        }*/
        await _auth.signInWithCredential(credential);

        // Successful login, redirect to GroceryListScreen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => GroceryListScreen()),
        );
      }
    } catch (e) {
      // Handle errors, such as showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Google Sign-In failed: $e")),
      );
    }
  }

  // Sign in with Email and Password
  Future<void> signInWithEmailPassword(
      String email, String password, BuildContext context) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      // Successful login, redirect to GroceryListScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => GroceryListScreen()),
      );
    } catch (e) {
      // Handle errors, such as showing a snackbar
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Email Sign-In failed: $e")),
      );
    }
  }
}
