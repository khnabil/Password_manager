import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

// Import our updated custom components and controllers
import 'package:pass_vault_app/controlers/auth_controller.dart';
import 'package:pass_vault_app/models/auth_repository.dart';
import 'package:pass_vault_app/models/credential.dart';
import 'package:pass_vault_app/views/screens/login_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive and register the adapter, but do not open the credentials box here.
  // The box will be opened by the CredentialController after a user logs in.
  await Hive.initFlutter();
  Hive.registerAdapter(CredentialAdapter());

  runApp(
    // We only need a single provider for AuthController at the app's root.
    ChangeNotifierProvider(
      create: (context) => AuthController(AuthRepository()),
      child: const PassVaultApp(),
    ),
  );
}

class PassVaultApp extends StatelessWidget {
  const PassVaultApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pass Vault',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      // The app now starts on our new login screen
      home: const LoginScreenWithUsername(),
    );
  }
}
