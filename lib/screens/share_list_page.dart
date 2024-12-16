import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ShareListPage extends StatelessWidget {
  final String listId;
  final String listName;

  const ShareListPage({Key? key, required this.listId, required this.listName})
      : super(key: key);

  Future<void> _sendEmail(String email, String listName) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
      queryParameters: {
        'subject': 'Partage de la liste : $listName',
        'body': 'Bonjour,\n\nVoici la liste "$listName".\n\nBonne journée !',
      },
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      print("Impossible d'ouvrir le client email.");
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
            // Champ pour saisir l'adresse email
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
            // Bouton pour envoyer par email
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  if (emailController.text.isNotEmpty) {
                    _sendEmail(emailController.text, listName);
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
