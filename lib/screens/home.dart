import 'package:flutter/material.dart';
import 'share_list_page.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final List<Map<String, String>> shoppingLists = [
    {'listId': '12345', 'listName': 'Courses du Samedi'},
    {'listId': '67890', 'listName': 'Courses Familiales'},
    {'listId': '11223', 'listName': 'Courses de Bureau'},
  ];

  void _shareByEmail(String listId, String listName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ShareListPage(
          listId: listId,
          listName: listName,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Lists'),
      ),
      body: ListView.builder(
        itemCount: shoppingLists.length,
        itemBuilder: (context, index) {
          final list = shoppingLists[index];
          return Card(
            child: ListTile(
              title: Text(list['listName']!),
              subtitle: Text('Liste ID: ${list['listId']}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Icône +
                  IconButton(
                    icon: Icon(Icons.add), // Icône pour partage par email
                    tooltip: "Partager par Email",
                    onPressed: () => _shareByEmail(list['listId']!, list['listName']!),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Fonction pour ajouter une nouvelle liste
          print('Ajouter une nouvelle liste');
        },
        child: Icon(Icons.add),
        tooltip: 'Ajouter une liste',
      ),
    );
  }
}
