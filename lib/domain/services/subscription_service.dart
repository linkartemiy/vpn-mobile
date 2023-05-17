import 'dart:math';

import 'package:ViewPN/domain/data_providers/subscription_data_provider.dart';
import 'package:ViewPN/domain/entities/subscription.dart';

class SubscriptionService {
  final _subscriptionDataProvider = SubscriptionDataProvider();

  Future<Subscription> getById(int id) async {
    return await _subscriptionDataProvider.getById(id);
  }

  Future<DateTime> pay(int id) async {
    return await _subscriptionDataProvider.pay(id);
  }
}
