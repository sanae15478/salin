import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/screens/authentification/auth.dart';
import 'package:salin/screens/authentification/signup.widgets/signup.dart';
import 'package:salin/screens/grocery/grocerylist.dart';
import 'package:salin/screens/authentification/EmailVerificationScreen.dart'; // Import Email Verification

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Salin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      initialRoute: '/auth',
      getPages: [
        GetPage(name: '/auth', page: () => AuthScreen()),
        GetPage(name: '/signup', page: () => SignupScreen()),
        GetPage(name: '/grocery', page: () => GroceryListScreen()),
        GetPage(name: '/verify-email', page: () => EmailVerificationScreen()), // Nouvelle route
      ],
    );
  }
}
