import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pass_vault_app/controlers/credential_controller.dart';
import 'package:pass_vault_app/models/credential.dart';

class HomeScreen extends StatelessWidget {
  final String username;
  const HomeScreen({super.key, required this.username});

  @override
  Widget build(BuildContext context) {
    // Provide the CredentialController here, after a successful login.
    // The username is used to open the correct Hive box.
    return ChangeNotifierProvider(
      create: (context) => CredentialController(username),
      child: Scaffold(
        appBar: AppBar(
          title: Text('$username\'s Passwords'),
        ),
        body: Consumer<CredentialController>(
          builder: (context, controller, child) {
            if (controller.credentials.isEmpty) {
              return const Center(
                child: Text(
                  'No passwords saved yet. Tap the "+" to add one!',
                  style: TextStyle(fontSize: 16, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              );
            }

            return ListView.builder(
              itemCount: controller.credentials.length,
              itemBuilder: (context, index) {
                final credential = controller.credentials[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: ListTile(
                    title: Text(credential.website),
                    subtitle: Text(credential.username),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () {
                        controller.deleteCredential(index);
                      },
                    ),
                    onTap: () {
                      // Navigate to a detail or edit page
                      // This is where you would implement the edit functionality
                    },
                  ),
                );
              },
            );
          },
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _showAddCredentialDialog(context);
          },
          child: const Icon(Icons.add),
        ),
      ),
    );
  }

  void _showAddCredentialDialog(BuildContext context) {
    final TextEditingController websiteController = TextEditingController();
    final TextEditingController usernameController = TextEditingController();
    final TextEditingController passwordController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Credential'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: websiteController,
                decoration: const InputDecoration(labelText: 'Website'),
              ),
              TextField(
                controller: usernameController,
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextField(
                controller: passwordController,
                decoration: const InputDecoration(labelText: 'Password'),
                obscureText: true,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                final newCredential = Credential(
                  website: websiteController.text,
                  username: usernameController.text,
                  password: passwordController.text,
                );
                Provider.of<CredentialController>(context, listen: false)
                    .addCredential(newCredential);
                Navigator.of(context).pop();
              },
              child: const Text('Add'),
            ),
          ],
        );
      },
    );
  }
}
