import 'dart:math';

import 'package:ViewPN/domain/data_providers/discount_data_provider.dart';
import 'package:ViewPN/domain/data_providers/server_data_provider.dart';
import 'package:ViewPN/domain/entities/discount.dart';
import 'package:ViewPN/domain/entities/server.dart';
import 'package:dart_ping/dart_ping.dart';

class DiscountService {
  final _discountDataProvider = DiscountDataProvider();
  late Discount _discount;
  Discount get discount => _discount;

  Future<void> initilalize() async {
    _discount = Discount.discountDefault;
  }

  Future<Discount> get(int id) async {
    Discount discount = await _discountDataProvider.get(id);
    return discount;
  }

  Future<Discount> apply(String code) async {
    Discount discount = await _discountDataProvider.apply(code);
    return discount;
  }
}
