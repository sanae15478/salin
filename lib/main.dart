import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/screens/HomeItem.dart';
import 'package:salin/screens/authentification/login.dart'; // Login screen


void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();  // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List App',
      home: const AuthenticationWrapper(),
    );
  }
}

class AuthenticationWrapper extends StatelessWidget {
  const AuthenticationWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Check if the user is logged in
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(), // Listen for auth state changes
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.active) {
          // If the user is logged in, show Home screen
          if (snapshot.hasData) {
            return  HomePage();
          } else {
            // If the user is not logged in, show Login screen
            return  AuthScreen();
          }
        }
        return const CircularProgressIndicator(); // Loading state
      },
    );
  }
}
