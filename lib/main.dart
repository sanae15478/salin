import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:salin/constants/colors.dart';
import 'package:salin/models/shopping_item.dart';
import 'package:salin/screens/authentification/login.dart';
import 'package:salin/screens/authentification/signup.dart';
import 'package:salin/screens/grocery/grocerylist.dart';
import 'package:salin/screens/authentification/EmailVerificationScreen.dart'; // Import Email Verification
import 'package:flutter/material.dart';
import 'package:salin/screens/ui/HomeScreen.dart';
import 'package:salin/screens/ui/home.dart';
import 'package:salin/screens/ui/shopping_list.dart';
import 'package:flutter/material.dart';
import 'controllers/homecontroller.dart';

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'controllers/homecontroller.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Shopping List App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // Initial route to the HomeScreen
      home:  HomeScreen(),
    );
  }
}


/*
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Map<String, List<ShoppingItem>> shoppingLists = {
    'Morning breakfast': [
      ShoppingItem(itemName: "Milk", category: "Dairy", quantity: 1),
      ShoppingItem(itemName: "Butter", category: "Dairy", quantity: 1),
      ShoppingItem(itemName: "Parmesan cheese", category: "Dairy", quantity: 1),
      ShoppingItem(itemName: "Eggs", category: "Dairy", quantity: 1),
      ShoppingItem(itemName: "Bread", category: "Bakery", quantity: 1),
      ShoppingItem(itemName: "Blueberry muffins", category: "Bakery", quantity: 1),
    ],
    'Dinner by Sarah': [],
    'Pizza day!': [],
    'Italian spaghetti': [],
    'Drinks': [],
  };

  String _view = 'home';

  void changeView(String newView) {
    setState(() {
      _view = newView;
    });
  }

  void addNewShoppingList(String newShoppingListName) {
    shoppingLists.putIfAbsent(newShoppingListName, () => []);
    setState(() {});
  }

  void addNewItem(ShoppingItem shoppingItem) {
    shoppingLists[_view]?.add(shoppingItem);
    setState(() {});
  }

  Widget getView() {
    if (_view == 'home') {
      return Home(
        shoppingLists: shoppingLists.keys.toList(),
        addNewShoppingList: addNewShoppingList,
        openShoppingList: changeView,
      );
    } else {
      return ShoppingList(
          title: _view,
          shoppingLists: shoppingLists[_view],
          addNewItem: addNewItem,
          crossOfItem: () {},
          exitList: changeView);
    }
  }

  @override
  Widget build(BuildContext context) {
    return getView();
  }
}*/




/*
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
*/