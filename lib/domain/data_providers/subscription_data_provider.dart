import 'dart:convert';

import 'package:ViewPN/domain/entities/subscription.dart';
import 'package:http/http.dart' as http;

class SubscriptionDataProvider {
  Future<List<Subscription>> getSubscriptions() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/subscriptions/get'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        });
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw Exception('Server error, try again later');
      } else {
        var subscriptionsData = data['subscriptions'];
        List<Subscription> subscriptions = [];
        for (int i = 0; i < subscriptionsData.length; i++) {
          subscriptions.add(Subscription.fromJson(subscriptionsData[i]));
        }
        return subscriptions;
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<Subscription> getById(int id) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/subscriptions/get'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, int>{'id': id}));
    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw Exception('Server error, try again later');
      } else {
        Subscription subscription = Subscription.fromJson(data['subscription']);
        return subscription;
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }

  Future<DateTime> pay(int id) async {
    await Future<void>.delayed(const Duration(seconds: 1));
    final response = await http.post(
        Uri.parse('http://5.252.22.128:3000/api/subscriptions/pay'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8'
        },
        body: jsonEncode(<String, int>{'id': id}));

    if (response.statusCode == 200) {
      var data = jsonDecode(response.body);
      if (data['status'] == 0) {
        throw Exception(data['message']);
      } else {
        return DateTime.parse(data['expiration_date']);
      }
    } else {
      throw Exception('Server error, try again later');
    }
  }
}
