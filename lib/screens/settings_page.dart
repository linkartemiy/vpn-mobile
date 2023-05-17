import 'package:ViewPN/domain/entities/server.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/domain/services/server_service.dart';
import 'package:ViewPN/domain/services/user_service.dart';
import 'package:ViewPN/screens/navigation/main_navigation.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

import 'package:flutter/material.dart';
import 'dart:async';

import 'package:openvpn_flutter/openvpn_flutter.dart';

import 'package:provider/provider.dart';

import '../domain/entities/user.dart';

class _ViewModelState {
  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();
  final _userService = UserService();
  User user = User.userDefault;

  var _state = _ViewModelState();
  _ViewModelState get state => _state;

  void loadValue() async {
    await _userService.initilalize();
    user = _userService.user;
    _updateState();
  }

  _ViewModel() {
    user = User.userDefault;
    loadValue();
    _updateState();
  }

  void _updateState() {
    _state = _ViewModelState();
    notifyListeners();
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const SettingsPage(),
    );
  }

  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {

  void navigateToHomePage(BuildContext context) {
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.read<_ViewModel>();

    return Scaffold(
        backgroundColor:
        AdaptiveTheme.of(context).theme.scaffoldBackgroundColor,
        appBar: AppBar(
          leading: IconButton(
              onPressed: () {
                navigateToHomePage(context);
              },
              icon: Icon(Icons.arrow_back)),
          title: Text('Settings', style: AdaptiveTheme.of(context).theme.appBarTheme.titleTextStyle,),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              children: [],
            )),
      );
  }
}
