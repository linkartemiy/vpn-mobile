import 'dart:math';

import 'package:ViewPN/domain/data_providers/user_data_provider.dart';
import 'package:ViewPN/domain/entities/user.dart';

import '../data_providers/session_data_provider.dart';

class UserService {
  final _userDataProvider = UserApiProvider();
  final _sessionDataProvider = SessionDataProvider();
  var _user;
  User get user => _user;

  Future<void> initilalize() async {
    var token = await _sessionDataProvider.token();
    if (token != null) {
      _user = await _userDataProvider.get(token);
    }
  }

  Future<void> cancelDiscount(int id) async {
    _user = await _userDataProvider.cancelDiscount(id);
  }

  Future<void> applyDiscount(int id, int discountId) async {
    _user = await _userDataProvider.applyDiscount(id, discountId);
  }

  Future<void> applyTrial(int id) async {
    _user = await _userDataProvider.applyTrial(id);
  }
}