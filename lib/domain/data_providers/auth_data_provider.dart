import 'dart:convert';

import '../entities/user.dart';
import 'package:http/http.dart' as http;

class AuthError {
  late String message;
  AuthError(message);
}

class AuthApiProvider {
  Future<User> login(String login, String password) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/login'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body:
            jsonEncode(<String, String>{'login': login, 'password': password}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else if (response.statusCode == 401) {
      throw Exception('Incorrect login or password');
    } else if (response.statusCode == 404) {
      throw Exception('User with this login doesn\'t exist');
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<User> register(String login, String password, String email) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/register'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'login': login, 'password': password, 'email': email}));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      return User.fromJson(data['user']);
    } else if (response.statusCode == 409) {
      throw Exception('User with this login already exists');
    } else {
      throw Exception('Server error, try again later');
    }
  }
}
