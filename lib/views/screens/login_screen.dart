import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
// Corrected the import path to match your folder structure
import 'package:Password_manager/controlers/auth_controller.dart';
import 'package:Password_manager/views/screens/home_screen.dart';

class LoginScreenWithUsername extends StatefulWidget {
  const LoginScreenWithUsername({super.key});

  @override
  State<LoginScreenWithUsername> createState() =>
      _LoginScreenWithUsernameState();
}

class _LoginScreenWithUsernameState extends State<LoginScreenWithUsername> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _isCreatingAccount = true;

  @override
  void initState() {
    super.initState();
    _checkIfAccountExists();
  }

  Future<void> _checkIfAccountExists() async {
    // Corrected to use AuthController
    final authController = Provider.of<AuthController>(context, listen: false);
    final hasPassword = await authController.hasMasterPassword();
    setState(() {
      _isCreatingAccount = !hasPassword;
    });
  }

  void _submit() async {
    if (_formKey.currentState!.validate()) {
      // Corrected to use AuthController
      final authController =
          Provider.of<AuthController>(context, listen: false);
      final username = _usernameController.text;
      final password = _passwordController.text;

      if (_isCreatingAccount) {
        // Now this method call will work on the AuthController
        await authController.createAccount(username, password);
        _navigateToHomeScreen();
      } else {
        // Now this method call will work on the AuthController
        final success = await authController.login(username, password);
        if (success) {
          _navigateToHomeScreen();
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
                content: Text('Invalid username or master password')),
          );
        }
      }
    }
  }

  void _navigateToHomeScreen() {
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => HomeScreen(username: _usernameController.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pass Vault'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  _isCreatingAccount ? 'Create Account' : 'Login',
                  style: const TextStyle(
                      fontSize: 24, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _usernameController,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Username',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a username';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                TextFormField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: 'Master Password',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter your master password';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: _submit,
                  child: Text(_isCreatingAccount ? 'Create Account' : 'Login'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
