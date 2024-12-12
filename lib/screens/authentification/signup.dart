import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../constants/colors.dart'; // Adjust the import path for kBackgroundColor

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordconfirmController = TextEditingController();

  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _passwordconfirmController.dispose();
    super.dispose();
  }

  Future<void> _signup() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Création d'un utilisateur avec Firebase Authentication
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim(),
        );

        // Rediriger vers l'écran de vérification d'email
        Get.offNamed('/verify-email');
      } on FirebaseAuthException catch (e) {
        String message;
        if (e.code == 'weak-password') {
          message = 'Le mot de passe est trop faible.';
        } else if (e.code == 'email-already-in-use') {
          message = 'Cet email est déjà utilisé.';

        } else {
          message = 'Une erreur est survenue. Veuillez réessayer.';
        }

        // Affichage d'un message d'erreur
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        backgroundColor: kBackgroundColor,
        elevation: 0,
      ),
      backgroundColor: kBackgroundColor,

      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Add an Icon or Image to the top of the signup screen
                Center(
                  child: Image.asset(
                    'assets/images/avatar.png',
                    height: 200,
                    width: 200,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(height: 40),



                // Email TextField with icon
                TextFormField(
                  controller: _emailController,
                  decoration: InputDecoration(
                    labelText: 'Email',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),


                  ),
                  keyboardType: TextInputType.emailAddress,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un email.';
                    }
                    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                      return 'Veuillez entrer un email valide.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password TextField with icon
                TextFormField(
                  controller: _passwordController,
                  decoration: InputDecoration(
                    labelText: 'Mot de passe',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),

                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),


                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer un mot de passe.';
                    }
                    if (value.length < 6) {
                      return 'Le mot de passe doit comporter au moins 6 caractères.';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),

                // Password TextField with icon
                TextFormField(
                  controller: _passwordconfirmController,
                  decoration: InputDecoration(
                    labelText: 'confirm Mot de passe',
                    labelStyle: TextStyle(color: Colors.grey[600]),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),

                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                        vertical: 18, horizontal: 20),


                  ),
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez confirmer le mot de passe.';
                    }
                    if (value.length != _passwordController.text.trim()) {
                      return 'Veuillez confirmer le mot de passe .';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 32),

                // Loading indicator or Sign Up Button
                _isLoading
                    ? Center(child: CircularProgressIndicator())
                    : ElevatedButton(
                  onPressed: _signup,
                  child: Text(
                    'Sign up',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 80),
                    elevation: 5,
                  ),
                ),
                SizedBox(height: 16),

                // Login text button with consistent style
                TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Retour à l'écran précédent
                  },
                  child: Text(
                    'already have an account  ? Login.',
                    style: TextStyle(fontSize: 14,
                      color: Colors.teal,), // Text color

                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
