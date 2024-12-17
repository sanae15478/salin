import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:salin/controllers/FirestoreService.dart';

import '../constants/colors.dart';

class ShareListPage extends StatefulWidget {
  final String listId;
  final String listName;

  ShareListPage({Key? key, required this.listId, required this.listName})
      : super(key: key);

  @override
  _ShareListPageState createState() => _ShareListPageState();
}

class _ShareListPageState extends State<ShareListPage> with SingleTickerProviderStateMixin {
  final FirestoreService _firestoreService = FirestoreService();
  final TextEditingController _emailController = TextEditingController();
  bool _isLoading = false;
  String? _errorMessage;

  late AnimationController _controllerAnimation;
  late Animation<double> _fieldAnimation;
  late Animation<double> _logoAnimation;

  @override
  void initState() {
    super.initState();

    _controllerAnimation = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: this,
    );

    _logoAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeInOut),
    );

    _fieldAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _controllerAnimation, curve: Curves.easeInOut),
    );

    _controllerAnimation.forward();
  }

  @override
  void dispose() {
    _controllerAnimation.dispose();
    super.dispose();
  }

  // Call the function to share the list
  Future<void> shareList(String email) async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    // Retrieve the shopping list document
    DocumentSnapshot listDoc = await FirebaseFirestore.instance.collection('shopping_lists').doc(widget.listId).get();

    if (listDoc.exists) {
      // Add shared email to the list document
      await FirebaseFirestore.instance.collection('shopping_lists').doc(widget.listId).update({
        'sharedWith': FieldValue.arrayUnion([email]),
      });

      // Provide user feedback
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('List shared with $email')));
    } else {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: List not found')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: kBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // Go back when the back button is pressed
          },
        ),
        title: Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: Text(
            'Partage de la liste : "${widget.listName}"',
            style: GoogleFonts.openSans(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Logo with animation (optional)
                  FadeTransition(
                    opacity: _logoAnimation,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - _logoAnimation.value)),
                      child: Image.asset(
                        'assets/images/avatar.png',
                        height: 180,
                        width: 180,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  const SizedBox(height: 40),



                  // Email field with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: TextField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: "Adresse Email",
                        labelStyle: GoogleFonts.openSans(color: Colors.grey[600]),
                        hintText: "Entrez l'email",
                        hintStyle: GoogleFonts.openSans(color: Colors.grey[400]),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(vertical: 18, horizontal: 20),
                        errorText: _errorMessage != null ? 'Please enter a valid email' : null,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Loading indicator or Share button with fade-in animation
                  FadeTransition(
                    opacity: _fieldAnimation,
                    child: _isLoading
                        ? CircularProgressIndicator()
                        : ElevatedButton(
                      onPressed: () {
                        if (_emailController.text.isNotEmpty) {
                          shareList(_emailController.text);
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Veuillez entrer une adresse email')),
                          );
                        }
                      },
                      child: Text(
                        'Partager la Liste',
                        style: GoogleFonts.roboto(fontSize: 16, fontWeight: FontWeight.w600),
                      ),
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.teal,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 70),
                        elevation: 5,
                      ),
                    ),
                  ),


                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
