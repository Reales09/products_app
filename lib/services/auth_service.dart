import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AuthService extends ChangeNotifier {
  final String _baseUrl = 'https://identitytoolkit.googleapis.com';
  final String _firebaseToken = 'AIzaSyDVpjQSFEE-TK59N4draOmJGho2xMfOkF4';

  Future<String?> createUser(String email, String password) async {
    final Map<String, dynamic> authData = {
      'email': email,
      'password': password,
      // 'returnSecureToken': true,
    };

    final url = Uri.http(_baseUrl, '/v1/accounts:signUp', {
      'key': _firebaseToken,
    });

    final resp = await http.post(url, body: json.encode(authData));
    final Map<String, dynamic> decodedResp = json.decode(resp.body);

    print(decodedResp);
  }
}