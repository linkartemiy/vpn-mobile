import 'package:ViewPN/domain/data_providers/auth_data_provider.dart';
import 'package:ViewPN/domain/entities/user.dart';
import 'package:ViewPN/domain/services/auth_service.dart';
import 'package:ViewPN/screens/navigation/main_navigation.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum _ViewModelAuthButtonState { canSubmit, authProcess, disable }

class _ViewModelState {
  String authErrorTitle = '';
  String login = '';
  String password = '';
  String email = '';
  bool isPasswordVisible = false;
  bool isAuthInProcess = false;

  _ViewModelAuthButtonState get authButtonState {
    if (isAuthInProcess) {
      return _ViewModelAuthButtonState.authProcess;
    } else if (login.isNotEmpty && password.isNotEmpty && email.isNotEmpty) {
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

  void changeEmail(String value) {
    if (_state.email == value) return;
    _state.email = value;
    notifyListeners();
  }

  Future<void> onAuthButtonPressed(BuildContext context) async {
    final login = _state.login;
    final password = _state.password;
    final email = _state.email;

    if (login.isEmpty || password.isEmpty || email.isEmpty) return;

    _state.authErrorTitle = '';
    _state.isAuthInProcess = true;
    notifyListeners();

    try {
      await _authService.register(login, password, email);
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

class RegisterPage extends StatelessWidget {
  const RegisterPage({Key? key}) : super(key: key);

  static Widget create() {
    return ChangeNotifierProvider(
      create: (_) => _ViewModel(),
      child: const RegisterPage(),
    );
  }

  void navigateToLoginPage(context) {
    Navigator.of(context).pop();
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
              _LoginWidget(),
              SizedBox(height: 10),
              _PasswordWidget(),
              SizedBox(height: 10),
              _EmailWidget(),
              SizedBox(height: 10),
              AuthButtonWidget(),
              SizedBox(height: 10),
              _ErrorTitleWidget(),
              SizedBox(height: 10),
              _ErrorsWidget(),
              SizedBox(height: 10),
              TextButton(
                  onPressed: () {
                    navigateToLoginPage(context);
                  },
                  child: Text('Sign in'))
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

class _EmailWidget extends StatelessWidget {
  const _EmailWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final model = context.read<_ViewModel>();
    return TextField(
      decoration: const InputDecoration(
        labelText: 'Email',
        border: OutlineInputBorder(),
      ),
      onChanged: model.changeEmail,
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
        ? const Text('Signing up')
        : const Text('Sign up');
    return ElevatedButton(
      onPressed: () => onPressed?.call(context),
      child: child,
    );
  }
}

class _ErrorsWidget extends StatelessWidget {
  const _ErrorsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final password = context.select((_ViewModel value) => value.state.password);
    bool passwordContainsSpecialCharacters =
        password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
    bool passwordContainsDigits = password.contains(RegExp(r'[0-9]'));
    bool passwordContainsLowerCase = password.contains(RegExp(r'[a-z]'));
    bool passwordContainsUpperCase = password.contains(RegExp(r'[A-Z]'));
    return Column(children: [
      Row(mainAxisSize: MainAxisSize.max, children: [
        Icon(
            color: password.length < 8
                ? AdaptiveTheme.of(context).theme.errorColor
                : Colors.green,
            password.length < 8
                ? Icons.check_circle_outline
                : Icons.check_circle),
        SizedBox(width: 10),
        Text(
          'Password should contain 8 characters at least',
          style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge?.copyWith(
              color: password.length < 8
                  ? AdaptiveTheme.of(context).theme.errorColor
                  : Colors.green),
        )
      ]),
      SizedBox(height: 10),
      Row(mainAxisSize: MainAxisSize.max, children: [
        Icon(
            color: !passwordContainsSpecialCharacters
                ? AdaptiveTheme.of(context).theme.errorColor
                : Colors.green,
            !passwordContainsSpecialCharacters
                ? Icons.check_circle_outline
                : Icons.check_circle),
        SizedBox(width: 10),
        Text(
          'Password should contain at least 1\nspecial character',
          style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge?.copyWith(
              color: !passwordContainsSpecialCharacters
                  ? AdaptiveTheme.of(context).theme.errorColor
                  : Colors.green),
        )
      ]),
      SizedBox(height: 10),
      Row(mainAxisSize: MainAxisSize.max, children: [
        Icon(
            color: !passwordContainsDigits
                ? AdaptiveTheme.of(context).theme.errorColor
                : Colors.green,
            !passwordContainsDigits
                ? Icons.check_circle_outline
                : Icons.check_circle),
        SizedBox(width: 10),
        Text(
          'Password should contain at least 1 digit',
          style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge?.copyWith(
              color: !passwordContainsDigits
                  ? AdaptiveTheme.of(context).theme.errorColor
                  : Colors.green),
        )
      ]),
      SizedBox(height: 10),
      Row(mainAxisSize: MainAxisSize.max, children: [
        Icon(
            color: !passwordContainsLowerCase
                ? AdaptiveTheme.of(context).theme.errorColor
                : Colors.green,
            !passwordContainsLowerCase
                ? Icons.check_circle_outline
                : Icons.check_circle),
        SizedBox(width: 10),
        Text(
          'Password should contain at least 1\nlowercase character',
          style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge?.copyWith(
              color: !passwordContainsLowerCase
                  ? AdaptiveTheme.of(context).theme.errorColor
                  : Colors.green),
        )
      ]),
      SizedBox(height: 10),
      Row(mainAxisSize: MainAxisSize.max, children: [
        Icon(
            color: !passwordContainsUpperCase
                ? AdaptiveTheme.of(context).theme.errorColor
                : Colors.green,
            !passwordContainsUpperCase
                ? Icons.check_circle_outline
                : Icons.check_circle),
        SizedBox(width: 10),
        Text(
          'Password should contain at least 1\nuppercase character',
          style: AdaptiveTheme.of(context).theme.textTheme.bodyLarge?.copyWith(
              color: !passwordContainsUpperCase
                  ? AdaptiveTheme.of(context).theme.errorColor
                  : Colors.green),
        )
      ])
    ]);
  }
}
