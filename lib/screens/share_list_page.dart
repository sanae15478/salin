import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:salin/controllers/FirestoreService.dart';

class ShareListPage extends StatelessWidget {
  final String listId;
  final String listName;

   ShareListPage({Key? key, required this.listId, required this.listName})
      : super(key: key);

  final FirestoreService _firestoreService = FirestoreService();

  Future<void> shareList(String email) async {
    // Retrieve the shopping list document
    DocumentSnapshot listDoc = await FirebaseFirestore.instance.collection('shopping_lists').doc(listId).get();

    if (listDoc.exists) {
      // Add shared email to the list document
      await FirebaseFirestore.instance.collection('shopping_lists').doc(listId).update({
        'sharedWith': FieldValue.arrayUnion([email]),
      });

      // Provide user feedback
      print('List shared successfully with $email');
    } else {
      print('Error: List not found');
    }
  }

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: Text('Partager la Liste'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Partage de la liste : "$listName"',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                labelText: 'Adresse Email',
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    shareList(emailController.text);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('List shared with ${emailController.text}')),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Veuillez entrer une adresse email')),
                    );
                  }
                },
                icon: Icon(Icons.send),
                label: Text('Envoyer par Email'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
