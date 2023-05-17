import 'dart:convert';

import 'package:ViewPN/domain/data_providers/auth_data_provider.dart';
import 'package:ViewPN/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class UserApiProvider {
  final sharedPreferences = SharedPreferences.getInstance();

  Future<User> get(String token) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/get'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'token': token}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw AuthError(data['message']);
      } else {
        return User.fromJson(data['user']);
      }
    } else if (response.statusCode == 404) {
      throw Exception('Server error, try again later');
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<bool> set(User user) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/set'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, User>{'user': user}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw AuthError(data['message']);
      } else {
        return true;
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<User> cancelDiscount(int id) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/discount/cancel'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, int>{'id': id}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw AuthError(data['message']);
      } else {
        return User.fromJson(data['user']);
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<User> applyDiscount(int id, int discountId) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/discount/apply'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, int>{'id': id, 'discount_id': discountId}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw AuthError(data['message']);
      } else {
        return User.fromJson(data['user']);
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<User> applyTrial(int id) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/users/trial/apply'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, int>{'id': id}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw AuthError(data['message']);
      } else {
        return User.fromJson(data['user']);
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }
}
