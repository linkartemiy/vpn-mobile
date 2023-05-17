import 'package:ViewPN/domain/data_providers/auth_data_provider.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/screens/navigation/main_navigation.dart';
import 'package:ViewPN/screens/register_page.dart';
import 'package:ViewPN/utils/constants.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _ViewModelAuthButtonState { canSubmit, authProcess, disable }

class _ViewModelState {
  String authErrorTitle = '';
  String login = '';
  String password = '';
  bool isPasswordVisible = false;
  bool isAuthInProcess = false;

  _ViewModelAuthButtonState get authButtonState {
    if (isAuthInProcess) {
      return _ViewModelAuthButtonState.authProcess;
    } else if (login.isNotEmpty && password.isNotEmpty) {
      return _ViewModelAuthButtonState.canSubmit;
    } else {
      return _ViewModelAuthButtonState.disable;
    }
  }

  _ViewModelState();
}

class _ViewModel extends ChangeNotifier {
  final _authService = AuthService();

  final _state = _ViewModelState();
  _ViewModelState get state => _state;
  bool get isPasswordVisible => _state.isPasswordVisible;
  void changePasswordVisibility(bool value) {
    if (_state.isPasswordVisible == value) return;
    _state.isPasswordVisible = value;
    notifyListeners();
  }

  void changeLogin(String value) {
    if (_state.login == value) return;
    _state.login = value;
    notifyListeners();
  }

  void changePassword(String value) {
    if (_state.password == value) return;
    _state.password = value;
    notifyListeners();
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;

    if (login.isEmpty || password.isEmpty) return;

    _state.authErrorTitle = '';
    _state.isAuthInProcess = true;
    notifyListeners();

    try {
      await _authService.login(login, password);
      _state.isAuthInProcess = false;
      notifyListeners();
      MainNavigation.showLoader(context);
    } on AuthError {
      _state.authErrorTitle = 'Incorrect login or password';
      _state.isAuthInProcess = false;
      notifyListeners();
    } catch (exception) {
      _state.authErrorTitle = exception.toString();
      _state.isAuthInProcess = false;
      notifyListeners();
    }
  }
}

class LoginPage extends StatelessWidget {
  const LoginPage({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const LoginPage(),
    );
  }

  void navigateToRegistrationPage(context) {
    Navigator.of(context).pushNamed('register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AdaptiveTheme.of(context).theme.backgroundColor,
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 10),
              _LoginWidget(),
              SizedBox(height: 10),
              _PasswordWidget(),
              SizedBox(height: 10),
              AuthButtonWidget(),
              SizedBox(height: 10),
              _ErrorTitleWidget(),
              SizedBox(height: 40),
              TextButton(
                  onPressed: () {
                    navigateToRegistrationPage(context);
                  },
                  child: Text('Sign up')),
            ],
          ),
        ),
      ),
    );
  }
}

class _LoginWidget extends StatelessWidget {
  const _LoginWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: InputDecoration(
        labelText: 'Login',
        border: OutlineInputBorder(),
      ),
      onChanged: model.changeLogin,
    );
  }
}

class _PasswordWidget extends StatelessWidget {
  const _PasswordWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final isPasswordVisible =
        context.select((_ViewModel value) => value.state.isPasswordVisible);
    return TextField(
      decoration: InputDecoration(
        labelText: 'Password',
        border: OutlineInputBorder(),
        suffixIcon: IconButton(
          icon: Icon(
            isPasswordVisible ? Icons.visibility : Icons.visibility_off,
            color: AdaptiveTheme.of(context).theme.primaryColor,
          ),
          onPressed: () {
            // Update the state i.e. toogle the state of passwordVisible variable
            model.changePasswordVisibility(!isPasswordVisible);
          },
        ),
      ),
      onChanged: model.changePassword,
      obscureText: !isPasswordVisible,
      enableSuggestions: false,
      autocorrect: false,
    );
  }
}

class _ErrorTitleWidget extends StatelessWidget {
  const _ErrorTitleWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final authErrorTitle =
        context.select((_ViewModel value) => value.state.authErrorTitle);
    return Text(
      authErrorTitle,
      style: TextStyle(color: AdaptiveTheme.of(context).theme.errorColor),
    );
  }
}

class AuthButtonWidget extends StatelessWidget {
  const AuthButtonWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    final authButtonState =
        context.select((_ViewModel value) => value.state.authButtonState);

    final onPressed = authButtonState == _ViewModelAuthButtonState.canSubmit
        ? model.onAuthButtonPressed
        : null;

    final child = authButtonState == _ViewModelAuthButtonState.authProcess
        ? const Text('Logging in')
        : const Text('Log in');
    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}
