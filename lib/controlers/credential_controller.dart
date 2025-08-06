import 'package:flutter/foundation.dart';
import 'package:pass_vault_app/models/credential.dart';
import 'package:hive_flutter/hive_flutter.dart';

class CredentialController with ChangeNotifier {
  final String _username;
  late final Box<Credential> _credentialBox;

  // The constructor now requires the username of the logged-in user.
  CredentialController(this._username) {
    _init();
  }

  // An asynchronous method to open the user-specific Hive box.
  // We use the username as the name of the box.
  Future<void> _init() async {
    _credentialBox = await Hive.openBox<Credential>(_username);
    notifyListeners();
  }

  List<Credential> get credentials => _credentialBox.values.toList();

  Future<void> addCredential(Credential credential) async {
    await _credentialBox.add(credential);
    notifyListeners();
  }

  Future<void> deleteCredential(int index) async {
    await _credentialBox.deleteAt(index);
    notifyListeners();
  }

  Future<void> updateCredential(int index, Credential credential) async {
    await _credentialBox.putAt(index, credential);
    notifyListeners();
  }
}
