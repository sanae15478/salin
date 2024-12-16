import 'package:flutter/material.dart';

class ShareListPage extends StatelessWidget {
  final String listName;

  const ShareListPage({Key? key, required this.listName}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final TextEditingController emailController = TextEditingController();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Partager la liste"),
        backgroundColor: Colors.teal,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Entrez l'adresse e-mail pour partager la liste :",
              style: TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: emailController,
              decoration: InputDecoration(
                hintText: "Adresse e-mail",
                border: OutlineInputBorder(),
                prefixIcon: const Icon(Icons.email),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                // Logique d'envoi d'e-mail
                print("Envoyer la liste '$listName' à ${emailController.text}");
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Liste '$listName' envoyée à ${emailController.text}")),
                );
              },
              icon: const Icon(Icons.send),
              label: const Text("Envoyer"),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
