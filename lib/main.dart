import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/constants/routes.dart';
import 'package:salin/controllers/main-controller.dart';
import 'package:salin/screens/home/home.dart';
import 'package:salin/screens/new-task/new-task.dart';
import 'package:salin/screens/loading/loading.dart';
import 'package:salin/screens/welcome/welcome.dart';
/*
void main() {
  runApp(App());
}

class App extends StatelessWidget {
  MainController mainController = Get.put(MainController());

  App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
      ),
      home: TestScreen(), // Set to TestScreen for navigation options
      routes: {
        loading_route: (context) => const LoadingScreen(),
        home_route: (context) => HomeScreen(),
        welcome_route: (context) => WelcomeScreen(),
        newtask_route: (context) => NewTaskScreen(),
      },
    );
  }
}

// Temporary TestScreen for quick navigation
class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Test Screens')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, loading_route),
              child: Text('Go to Loading Screen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, home_route),
              child: Text('Go to Home Screen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, welcome_route),
              child: Text('Go to Welcome Screen'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pushNamed(context, newtask_route),
              child: Text('Go to New Task Screen'),
            ),
          ],
        ),
      ),
    );
  }
}
*/

void main() {
  runApp(App());
}

// ignore: must_be_immutable
class App extends StatelessWidget {
  MainController mainController = Get.put(MainController());
  final String initRoute = loading_route;

  App({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Tasker',
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
