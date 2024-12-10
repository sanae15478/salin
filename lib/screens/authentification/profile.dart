import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:salin/screens/authentification/login.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Get the current user from Firebase Auth
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(

      appBar: AppBar(
        surfaceTintColor: Colors.orange,
        backgroundColor: Colors.white,
        title: Text('Profile'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () async {
              await FirebaseAuth.instance.signOut();
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => AuthScreen()),
              );
            },
          ),
        ],
      ),
      body: user != null
          ? Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Display user profile information
            CircleAvatar(
              radius: 100,
              backgroundImage: user.photoURL != null
                  ? NetworkImage(user.photoURL!)
                  : AssetImage("assets/images/profile.jpg") as ImageProvider,
            ),
            SizedBox(height: 20),
            Text(
              'Name: ${user.displayName ?? 'No name'}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 10),
            Text(
              'Email: ${user.email ?? 'No email'}',
              style: TextStyle(fontSize: 18),
            ),

          ],
        ),
      )
          : Center(
        child: Text('No user is logged in'),
      ),
    );
  }
}
