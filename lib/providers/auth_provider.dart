import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/keys/google_api_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String? _userId;
  Timer? _timer;

  bool get isAuth {
    return token != null;
  }
  String? get token {
    if (_token != null && _expiryDate != null && _expiryDate!.isAfter(DateTime.now())) {
      return _token!;
    }
    return null;
  }

  String? get userId => _userId;

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
      print(body);
      _token = body['idToken'];
      _userId = body['localId'];
      _expiryDate = DateTime.now().add(Duration(seconds: int.parse(body['expiresIn'])));
      _autoSignOut();
      notifyListeners();

    final prefs = await SharedPreferences.getInstance();

    final userData = {
      'userId': _userId,
      'token': _token,
      'expiryDate': _expiryDate!.toIso8601String()
    };
    prefs.setString('userLogs', jsonEncode(userData));

    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userLogs')) {
      return false;
    }
    final Map<String, dynamic> extractedUserData = jsonDecode(prefs.get('userLogs') as String);
    final DateTime expiryDate = DateTime.parse(extractedUserData['expiryDate']!);

    if  (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = extractedUserData['token'];
    _userId = extractedUserData['userId'];
    _expiryDate = expiryDate;
    notifyListeners();
    _autoSignOut();
    return true;
  }

  Future<void> signUp(String email, String password) async {
    return _authenticate(email: email, password: password, urlSegment: _signUpEndPoint);
  }

  Future<void> signIn(String email, String password) async {
    return _authenticate(email: email, password: password, urlSegment: _signInEndPoint);
  }

  void signOut() async {
    _token = null;
    _userId = null;
    _expiryDate = null;
    if (_timer != null) {
      _timer!.cancel();
    }
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('userLogs');
  }

  void _autoSignOut() {
    if (_timer != null) {
      _timer!.cancel();
    }
    final timeToExpiry = _expiryDate!.difference(DateTime.now()).inSeconds;
    _timer = Timer(
      Duration(seconds: timeToExpiry),
      () => signOut()
    );
  }
}