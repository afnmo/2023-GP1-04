import 'dart:convert';

import 'package:crypto/crypto.dart';


class UserModel {
  final String? id;
  final String? name;
  final String? email;
  final String? password;

  const UserModel({
    this.id,
    required this.name,
    required this.email,
    required this.password,
  });

  toJson() {
    return {
      "name": name,
      "email": email,
      "password": hashPassword(password!),
    };
  }

  String hashPassword(String password) {
    // Convert password to bytes
    var bytes = utf8.encode(password);
    // Hash the bytes
    var digest = sha256.convert(bytes);

    return digest.toString();
  }
}
