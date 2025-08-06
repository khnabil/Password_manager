// lib/controlers/auth_controller.dart

import 'package:flutter/foundation.dart';
import 'package:pass_vault_app/models/auth_repository.dart'; // Corrected import path

class AuthController with ChangeNotifier {
  final AuthRepository _authRepository;
  String? _currentUser;

  AuthController(this._authRepository);

  String? get currentUser => _currentUser;

  Future<bool> hasMasterPassword() async {
    final passwords = await _authRepository.getMasterPasswords();
    return passwords != null && passwords.isNotEmpty;
  }

  Future<void> createAccount(String username, String password) async {
    await _authRepository.saveMasterPassword(username, password);
    _currentUser = username;
    notifyListeners();
  }

  Future<bool> login(String username, String password) async {
    final storedPassword = await _authRepository.getMasterPassword(username);
    if (storedPassword == password) {
      _currentUser = username;
      notifyListeners();
      return true;
    }
    return false;
  }
}
