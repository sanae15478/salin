import 'package:shared_preferences/shared_preferences.dart';

Future<bool?> checkFirstEnter() async {
  SharedPreferences prefs = await SharedPreferences.getInstance();

  bool? firstEnterStatus;
  firstEnterStatus = prefs.getBool('first-enter');

  return firstEnterStatus;
}
