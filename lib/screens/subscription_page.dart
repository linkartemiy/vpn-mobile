import 'package:ViewPN/domain/entities/discount.dart';
import 'package:ViewPN/domain/entities/server.dart';
import 'package:ViewPN/domain/entities/subscription.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/domain/services/discount_service.dart';
import 'package:ViewPN/domain/services/server_service.dart';
import 'package:ViewPN/domain/services/subscription_service.dart';
import 'package:ViewPN/domain/services/user_service.dart';
import 'package:ViewPN/screens/home_page.dart';
import 'package:ViewPN/screens/navigation/main_navigation.dart';
import 'package:ViewPN/screens/widgets/appbar.dart';
import 'package:ViewPN/screens/widgets/error.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'dart:async';

import 'package:openvpn_flutter/openvpn_flutter.dart';

import 'package:provider/provider.dart';

import '../domain/entities/user.dart';

class SubscriptionPageArguments {
  Subscription subscription;
  Discount discount;
  User user;
  SubscriptionPageArguments(
      {required this.user, required this.subscription, required this.discount});
}

class _ViewModelState {
  User? user;
  Subscription? subscription;
  Discount? discount;
  _ViewModelState({this.user, this.subscription, this.discount});
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  final _subscriptionService = SubscriptionService();
  final _discountService = DiscountService();
  User user = User.userDefault;
  Subscription subscription = Subscription.subscriptionDefault;
  Discount discount = Discount.discountDefault;
  String discountCode = '';
  String discountError = '';

  var _state = _ViewModelState();
  _ViewModelState get state => _state;

  void loadValue() async {
    await _userService.initilalize();
    user = _userService.user;

    subscription = await _subscriptionService.getById(user.subscriptionId);

    if (user.discountId != -1) {
      discount = await _discountService.get(user.discountId);
    }

    _updateState();
  }

  void pay() async {
    user.expirationDate = await _subscriptionService.pay(user.id);
    _updateState();
  }

  Future<void> cancelDiscount() async {
    await _userService.cancelDiscount(user.id);
    user = _userService.user;
    subscription = await _subscriptionService.getById(user.subscriptionId);

    if (user.discountId != -1) {
      discount = await _discountService.get(user.discountId);
    }
    _updateState();
  }

  void changeDiscount(String value) {
    if (discountCode == value) return;
    discountCode = value;
    notifyListeners();
  }

  Future<Discount> getDiscountById(int id) async {
    return await _discountService.get(id);
  }

  Future<void> applyDiscount() async {
    try {
      Discount discountApplied = await _discountService.apply(discountCode);
      discount = discountApplied;
      user.discountId = discount.id;
      await _userService.applyDiscount(user.id, discount.id);
      user = _userService.user;
      discountCode = '';
      discountError = '';
      _updateState();
    } catch (exception) {
      discountCode = '';
      discountError = exception.toString();
      _updateState();
    }
  }

  Future<void> applyTrial() async {
    await _userService.applyTrial(user.id);
    user = _userService.user;
    _updateState();
  }

  _ViewModel(SubscriptionPageArguments subscriptionPageArguments) {
    user = subscriptionPageArguments.user;
    subscription = subscriptionPageArguments.subscription;
    discount = subscriptionPageArguments.discount;
    loadValue();
    _updateState();
  }

  void _updateState() {
    _state = _ViewModelState(
        user: user, subscription: subscription, discount: discount);
    notifyListeners();
  }
}

class SubscriptionPage extends StatefulWidget {
  const SubscriptionPage({Key? key}) : super(key: key);

  static Widget create(SubscriptionPageArguments subscriptionPageArguments) {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(subscriptionPageArguments),
      child: const SubscriptionPage(),
    );
  }

  @override
  _SubscriptionPage createState() => _SubscriptionPage();
}

class _SubscriptionPage extends State<SubscriptionPage> {
  @override
  void initState() {
    for (int i = 1; i < 5; i++) {
      int time = 500 * i;
      Future.delayed(Duration(milliseconds: time), () {
        setState(() {});
      });
    }
    super.initState();
  }

  void navigateToHomePage(BuildContext context, viewModel) {
    Navigator.of(context).pop(HomePageArguments(
        user: viewModel.user,
        subscription: viewModel.subscription,
        discount: viewModel.discount));
  }

  Future<void> pay(viewModel) async {
    await viewModel.pay();
    setState(() {});
  }

  Future<void> cancelDiscount(viewModel) async {
    await viewModel.cancelDiscount();
    setState(() {});
  }

  bool applyDiscount = false;

  void toggleDiscount() {
    applyDiscount = !applyDiscount;
    setState(() {});
  }

  Future<void> applyDiscountCode(viewModel) async {
    await viewModel.applyDiscount();
    setState(() {});
  }

  Future<void> applyTrial(viewModel) async {
    await viewModel.applyTrial();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
      appBar: AppBarWidget(
          navigate: () {
            navigateToHomePage(context, viewModel);
          },
          title: 'My subscription',
          textButton: viewModel.user.trialAvailable &&
                  DateTime.now().compareTo(viewModel.user.expirationDate) >= 0
              ? Column(children: [
                  TextButton(
                      onPressed: () {
                        applyTrial(viewModel);
                      },
                      child: Text('Try for free'))
                ])
              : Container()),
      body: Container(
          padding: EdgeInsets.all(10),
          alignment: Alignment.center,
          child: viewModel.user.discountId == 1
              ? Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Unlimited discount',
                      style: AdaptiveTheme.of(context)
                          .theme
                          .textTheme
                          .headlineSmall,
                    ),
                    TextButton(
                        onPressed: () {
                          cancelDiscount(viewModel);
                        },
                        child: Text(
                          'Cancel discount',
                          style: AdaptiveTheme.of(context)
                              .theme
                              .textTheme
                              .titleMedium
                              ?.copyWith(
                                  color: AdaptiveTheme.of(context)
                                      .theme
                                      .errorColor),
                        ))
                  ],
                )
              : Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    DateTime.now().compareTo(viewModel.user.expirationDate) == 1 && DateTime.now().compareTo(viewModel.user.trialExpirationDate) >= 0
                        ? Column(children: [
                            Text('Subscription is expired',
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .titleLarge),
                          ])
                        : Column(children: [
                            Text('Paid till',
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .titleSmall),
                            Text(
                                DateFormat('yyyy-MM-dd hh:mm:ss').format(
                                DateTime.now().compareTo(viewModel.user.trialExpirationDate) >= 0 ? viewModel.user.trialExpirationDate.toLocal() : viewModel.user.expirationDate.toLocal()),
                                style: AdaptiveTheme.of(context)
                                    .theme
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(fontWeight: FontWeight.bold))
                          ]),
          DateTime.now().compareTo(viewModel.user.trialExpirationDate) >= 0 ? Column(
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            pay(viewModel);
                          },
                          child: Text(
                            'Pay for a month',
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                    color: AdaptiveTheme.of(context)
                                        .theme
                                        .buttonTheme
                                        .colorScheme
                                        ?.secondary),
                          ),
                          style: AdaptiveTheme.of(context)
                              .theme
                              .elevatedButtonTheme
                              .style
                              ?.copyWith(
                                  minimumSize: MaterialStateProperty.all<Size>(
                                      Size(300, 60))),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: viewModel.user.discountId == -1
                              ? [
                                  TextButton(
                                      onPressed: toggleDiscount,
                                      child: Text(applyDiscount
                                          ? 'Cancel'
                                          : 'Apply discount')),
                                  applyDiscount
                                      ? TextButton(
                                          onPressed: () {
                                            applyDiscountCode(viewModel);
                                          },
                                          child: Text('Apply'))
                                      : SizedBox(
                                          width: 0,
                                        )
                                ]
                              : [
                                  TextButton(
                                      onPressed: () {
                                        cancelDiscount(viewModel);
                                      },
                                      child: Text('Cancel activated discount'))
                                ],
                        ),
                        applyDiscount && viewModel.user.discountId == -1
                            ? Column(children: [
                                SizedBox(
                                  width: 100,
                                  child: TextField(
                                    decoration: InputDecoration(
                                      labelText: 'Code',
                                      border: UnderlineInputBorder(),
                                    ),
                                    onChanged: viewModel.changeDiscount,
                                  ),
                                ),
                                viewModel.discountError.isNotEmpty
                                    ? Container(
                                        margin: EdgeInsets.only(top: 10),
                                        child: ErrorTextWidget(
                                            viewModel.discountError))
                                    : Container()
                              ])
                            : Container()
                      ],
                    ) : Container(),
                    Column(
                      children: [
                        Text(viewModel.subscription.name.toString(),
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .titleSmall
                                ?.copyWith(
                                    color: AdaptiveTheme.of(context)
                                        .theme
                                        .colorScheme
                                        .primary,
                                    fontWeight: FontWeight.bold)),
                        Text(
                            (viewModel.user.discountId != -1
                                        ? (viewModel.subscription.price *
                                            (1 -
                                                viewModel.discount.percent /
                                                    100))
                                        : viewModel.subscription.price)
                                    .toString() +
                                '\$ per ' +
                                viewModel.subscription.measure,
                            style: AdaptiveTheme.of(context)
                                .theme
                                .textTheme
                                .headline5),
                        viewModel.user.discountId != -1
                            ? Column(children: [
                                Text('Activated discount: ' +
                                    viewModel.discount.name +
                                    ' (-' +
                                    viewModel.discount.percent.toString() +
                                    '%)')
                              ])
                            : Text('No discount activated'),
                      ],
                    )
                  ],
                )),
    );
  }
}
