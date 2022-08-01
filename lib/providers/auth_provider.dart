import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/keys/google_api_keys.dart';

class AuthProvider with ChangeNotifier {
  late String _token;
  late DateTime _expiryDate;
  late String _userId;

  final String _baseUrl = 'https://www.googleapis.com/identitytoolkit/v3/relyingparty/';
  final String _signUpEndPoint = 'signupNewUser';
  final String _signInEndPoint = 'verifyPassword';
  Future<void> _authenticate({required String email, required String password, required String urlSegment}) async {
    try {
      final url = Uri.parse('$_baseUrl$urlSegment$googleApiKey');
      final response = await http.post(
        url,
        body: json.encode({
          'email': email,
          'password': password,
          'returnSecureToken': true,
        },),
      );
      final Map<String, dynamic> body = jsonDecode(response.body);
      if (body.containsKey('error')) {
        throw HttpException(body['error']['message']);
      }
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email: email, password: password, urlSegment: _signUpEndPoint);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email: email, password: password, urlSegment: _signInEndPoint);
  }
}