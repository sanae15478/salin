import 'package:salin/models/user/user-email.dart';
import 'package:salin/models/user/user-name.dart';

Future<bool> UpdateUserData({String? name, String? email, String? age}) async {
  if (name != null && name.isNotEmpty) {
    // Await the result of setUserName to ensure the update is completed before continuing
    await setUserName(userName: name);
  }

  if (email != null && email.isNotEmpty) {
    // Await the result of setUserEmail to ensure the update is completed before continuing
    await setUserEmail(userEmail: email);
  }

  // You can similarly await the age if there's an associated function to handle age update.
  // For now, I'm assuming you may have a similar function for updating age if necessary.

  return true; // Assuming the function will always return true if no errors occurred.
}
