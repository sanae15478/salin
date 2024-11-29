import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class EmailVerificationScreen extends StatefulWidget {
  @override
  _EmailVerificationScreenState createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? _user;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _user = _auth.currentUser;

    // Envoyer un email de vérification si ce n'est pas déjà fait
    if (!_user!.emailVerified) {
      _user!.sendEmailVerification();
    }

    // Vérifier périodiquement si l'email est validé
    _timer = Timer.periodic(Duration(seconds: 3), (_) => _checkEmailVerified());
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkEmailVerified() async {
    await _user!.reload();
    if (_user!.emailVerified) {
      _timer?.cancel();
      // Naviguer vers l'écran des courses
      Navigator.pushReplacementNamed(context, '/grocery');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vérification de l\'email'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.email,
                size: 100,
                color: Colors.blue,
              ),
              SizedBox(height: 20),
              Text(
                'Un email de vérification a été envoyé à ${_user!.email}.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  if (!_user!.emailVerified) {
                    await _user!.sendEmailVerification();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Email de vérification renvoyé.'),
                      ),
                    );
                  }
                },
                child: Text('Renvoyer l\'email de vérification'),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () async {
                  await FirebaseAuth.instance.signOut();
                  Navigator.pushReplacementNamed(context, '/auth');
                },
                child: Text('Se déconnecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
