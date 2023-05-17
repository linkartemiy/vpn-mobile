import 'dart:convert';

import 'package:ViewPN/domain/data_providers/auth_data_provider.dart';
import 'package:ViewPN/domain/entities/discount.dart';
import 'package:ViewPN/domain/entities/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class DiscountDataProvider {
  Future<Discount> get(int id) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/discounts/get'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, int>{'id': id}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw Exception(data['message']);
      } else {
        return Discount.fromJson(data['discount']);
      }
    } else if (response.statusCode == 404) {
      throw Exception('Server error, try again later');
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<Discount> apply(String code) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/discounts/apply'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, String>{'code': code}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw Exception(data['message']);
      } else {
        return Discount.fromJson(data['discount']);
      }
    } else if (response.statusCode == 404) {
      throw Exception('Server error, try again later');
    } else {
      throw Exception('Server error, try again later');
    }
  }
}
