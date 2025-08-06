import 'package:hive/hive.dart';

part 'credential.g.dart'; // Hive will generate this file for us

@HiveType(typeId: 0)
class Credential extends HiveObject {
  @HiveField(0)
  late String website;

  @HiveField(1)
  late String username;

  @HiveField(2)
  late String password;

  @HiveField(3)
  String? notes;

  Credential({
    required this.website,
    required this.username,
    required this.password,
    this.notes,
  });
}
