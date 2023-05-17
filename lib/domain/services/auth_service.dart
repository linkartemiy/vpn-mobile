import 'package:ViewPN/domain/data_providers/auth_data_provider.dart';
import 'package:ViewPN/domain/data_providers/session_data_provider.dart';

import '../entities/user.dart';

class AuthService {
  final _sessionDataProvider = SessionDataProvider();
  final _authApiProvider = AuthApiProvider();

  Future<bool> checkAuth() async {
    final token = await _sessionDataProvider.token();
    if (token == null || token.isEmpty) {
      return false;
    } else {
      return true;
    }
  }

  Future<void> login(String login, String password) async {
    final user = await _authApiProvider.login(login, password);
    await _sessionDataProvider.saveToken(user.token);
  }

  Future<void> register(String login, String password, String email) async {
    final userReceived = await _authApiProvider.register(login, password, email);
    await _sessionDataProvider.saveToken(userReceived.token);
  }

  Future<void> logout() async {
    await _sessionDataProvider.clearToken();
  }
}
