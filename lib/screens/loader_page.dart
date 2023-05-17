import 'package:ViewPN/domain/entities/discount.dart';
import 'package:ViewPN/domain/entities/subscription.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/screens/home_page.dart';
import 'package:ViewPN/utils/constants.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../domain/services/discount_service.dart';
import '../domain/services/server_service.dart';
import '../domain/services/subscription_service.dart';
import '../domain/services/user_service.dart';

class _ViewModel {
  final _authService = AuthService();
  final _serverService = ServerService();
  final _userService = UserService();
  final _subscriptionService = SubscriptionService();
  final _discountService = DiscountService();
  Subscription subscription = Subscription.subscriptionDefault;
  Discount discount = Discount.discountDefault;
  BuildContext context;

  _ViewModel(this.context) {
    init();
  }

  void init() async {
    final isAuth = await _authService.checkAuth();
    if (isAuth) {
      await _serverService.initilalize();
      try {
        await _userService.initilalize();
        subscription = await _subscriptionService
            .getById(_userService.user.subscriptionId);

        if (_userService.user.discountId != -1) {
          discount = await _discountService.get(_userService.user.discountId);
        }
        _goToAppScreen();
      } on Exception catch (e) {
        await _authService.logout();
        _goToAuthScreen();
      }
    } else {
      _goToAuthScreen();
    }
  }

  void _goToAuthScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil('login', (route) => false);
  }

  void _goToAppScreen() {
    Navigator.of(context).pushNamedAndRemoveUntil('home', (route) => false,
        arguments: HomePageArguments(
            user: _userService.user,
            subscription: subscription,
            discount: discount));
  }
}

class LoaderPage extends StatelessWidget {
  const LoaderPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
        color: secondaryColor,
      )),
    );
  }

  static Widget create() {
    return Provider(
      create: (context) => _ViewModel(context),
      child: const LoaderPage(),
      lazy: false,
    );
  }
}

class LoaderWidget extends StatelessWidget {
  const LoaderWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
          child: CircularProgressIndicator(
            color: secondaryColor,
          )),
    );
  }
}

