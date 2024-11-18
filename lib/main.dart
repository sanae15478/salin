import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/routes.dart';
import 'package:salin/controllers/main-controller.dart';
import 'package:salin/screens/authentification/auth.dart';
import 'package:salin/screens/authentification/login.dart';
import 'package:salin/screens/home/home.dart';
import 'package:salin/screens/new-task/new-task.dart';
import 'package:salin/screens/loading/loading.dart';
import 'package:salin/screens/welcome/welcome.dart';
/*
void main() {
  runApp(App());
}*/

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MyApp());
}
/*
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Salin',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: kPrimaryColor,
        ),
        home: AuthScreen());
  }
}
*/

// ignore: must_be_immutable
class MyApp extends StatelessWidget {
  MainController mainController = Get.put(MainController());
  final String initRoute = loading_route;

  MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Salin',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      initialRoute: initRoute,
      routes: {
        loading_route: (context) => const LoadingScreen(),
        home_route: (context) => HomeScreen(),
        welcome_route: (context) => WelcomeScreen(),
        newtask_route: (context) => NewTaskScreen(),
      },
    );
  }
}
