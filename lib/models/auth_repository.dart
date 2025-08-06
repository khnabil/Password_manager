// lib/models/auth_repository.dart

import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthRepository {
  final _secureStorage = const FlutterSecureStorage();
  static const _passwordsKey = 'master_passwords_map';

  Future<void> saveMasterPassword(String username, String password) async {
    final allPasswords = await getMasterPasswords() ?? {};
    allPasswords[username] = password;
    await _secureStorage.write(
        key: _passwordsKey, value: jsonEncode(allPasswords));
  }

  Future<String?> getMasterPassword(String username) async {
    final allPasswords = await getMasterPasswords();
    return allPasswords?[username];
  }

  Future<Map<String, String>?> getMasterPasswords() async {
    final passwordsString = await _secureStorage.read(key: _passwordsKey);
    if (passwordsString == null || passwordsString.isEmpty) {
      return null;
    }
    // Safely decode the JSON string back into a Map
    try {
      return Map<String, String>.from(jsonDecode(passwordsString));
    } catch (e) {
      // In case of a parsing error, return null
      return null;
    }
  }

  Future<bool> hasMasterPassword() async {
    final passwords = await getMasterPasswords();
    // Use a null-aware check to prevent the error
    return passwords != null && passwords.isNotEmpty;
  }
}
