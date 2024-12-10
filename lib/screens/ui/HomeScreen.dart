import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import '../../controllers/homecontroller.dart';
import '../../models/shopping_item.dart';
import '../authentification/login.dart';
import '../authentification/signup.dart';


class HomeScreen extends StatelessWidget {
  final Controller _controller = Controller();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Shopping Lists")),
      body: FutureBuilder<List<String>>(
        future: _controller.getShoppingLists(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No lists available"));
          }

          List<String> shoppingLists = snapshot.data!;

          return ListView.builder(
            itemCount: shoppingLists.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(shoppingLists[index]),
                trailing: IconButton(
                  icon: Icon(Icons.share),
                  onPressed: () async {
                    List<ShoppingItem> items = await _controller.getListLocally(shoppingLists[index]);
                    await _controller.syncListToFirebase(shoppingLists[index], items);
                  },
                ),
              );
            },
          );
        },
      ),
      // Logout Button
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await _controller.logout();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AuthScreen()),
          );

        },
        child: Icon(Icons.exit_to_app),
        tooltip: 'Logout',
      ),
    );
  }
}
