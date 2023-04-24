import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'user.dart';

class Users with ChangeNotifier {
  List<User> _users = [];

  void addUser(User user) {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/users.json');
    final response = http.post(url,
        body: json.encode({
          'id': user.id,
          'firstName': user.firstName,
          'lastName': user.lastName,
          'email': user.email,
          'role': user.role,
        }));
  }

  List<User> get users {
    return [..._users];
  }

  Future<void> getUsers() async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/users.json');
    try {
      final response = await http.get(url);
      final responseBody = json.decode(response.body) as Map<String, dynamic>;
      final List<User> loadedUsers = [];
      responseBody.forEach((userId, user) {
        loadedUsers.add(User(
          id: userId,
          firstName: user['firstName'],
          lastName: user['lastName'],
          email: user['email'],
          role: user['role'],
        ));
      });
      _users = loadedUsers;
      notifyListeners();
    } catch (error) {
      rethrow;
    }
  }

  Future<void> changeUserRole(String userId, String role) async {
    final url = Uri.parse(
        'https://universal-price-list-default-rtdb.europe-west1.firebasedatabase.app/users/$userId.json');
    try {
      final response = http.patch(url,
          body: json.encode({
            'role': role,
          }));
    } catch (error) {
      rethrow;
    }
  }
}
