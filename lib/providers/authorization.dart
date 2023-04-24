import 'dart:convert';
import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import './users.dart';
import './user.dart';
import '../config/config.dart';

class Authorization with ChangeNotifier {
  String? _token;
  DateTime? _expiryDate;
  String _userId = "";
  String _userRole = "";
  String _userName = "";

  bool get isAuth {
    return token != null;
  }

  String? get token {
    if (_expiryDate != null &&
        _expiryDate!.isAfter(DateTime.now()) &&
        _token != null) {
      return _token!;
    }
    return null;
  }

  String get userId {
    return _userId;
  }

  String get userRole {
    return _userRole;
  }

  String get userName {
    return _userName;
  }

  Future<void> signup(
      String firstName, String lastName, String email, String password) async {
    final url = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signUp?key=${Config.apikey}');
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      } else {
        User newUser = User(
            id: responseBody['localId'],
            email: email,
            firstName: firstName,
            lastName: lastName,
            role: "User");
        var users = Users();
        users.addUser(newUser);
      }
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> signin(String email, String password) async {
    final urlAuth = Uri.parse(
        'https://identitytoolkit.googleapis.com/v1/accounts:signInWithPassword?key=${Config.apikey}');
    try {
      final response = await http.post(
        urlAuth,
        body: json.encode(
          {
            'email': email,
            'password': password,
            'returnSecureToken': true,
          },
        ),
      );
      var responseBody = json.decode(response.body);
      if (responseBody['error'] != null) {
        throw HttpException(responseBody['error']['message']);
      }
      _token = responseBody['idToken'];
      _userId = responseBody['localId'];
      _expiryDate = DateTime.now().add(
        Duration(
          seconds: int.parse(responseBody['expiresIn']),
        ),
      );
    } catch (error) {
      rethrow;
    }

    final urlUser = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/users.json');
    try {
      final response = await http.get(urlUser);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<User> loadedUsers = [];
      responseBody.forEach((userId, user) {
        loadedUsers.add(User(
          id: user['id'],
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          role: user['role'],
        ));
      });
      var currentUser =
          loadedUsers.where((element) => element.id == _userId).first;

      _userRole = currentUser.role;
      _userName = currentUser.firstName;
      notifyListeners();
      final prefs = await SharedPreferences.getInstance();
      final userData = json.encode({
        'token': _token,
        'userId': _userId,
        'userName': userName,
        'userRole': userRole,
        'expiryDate': _expiryDate!.toIso8601String()
      });
      prefs.setString('userData', userData);
    } catch (error) {
      rethrow;
    }
  }

  Future<bool> tryAutoSignIn() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('userData')) {
      return false;
    }
    final fetchedUserData =
        json.decode(prefs.getString('userData')!) as Map<String, dynamic>;
    final expiryDate = DateTime.parse(fetchedUserData['expiryDate']);

    if (expiryDate.isBefore(DateTime.now())) {
      return false;
    }

    _token = fetchedUserData['token'];
    _userId = fetchedUserData['userId'];
    _userName = fetchedUserData['userName'];
    _userRole = fetchedUserData['userRole'];
    _expiryDate = expiryDate;
    notifyListeners();
    return true;
  }

  Future<void> logout() async {
    _token = null;
    _expiryDate = null;
    _userId = "";
    _userRole = "";
    _userName = "";
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }
}
