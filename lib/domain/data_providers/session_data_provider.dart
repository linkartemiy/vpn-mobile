import 'package:shared_preferences/shared_preferences.dart';

abstract class SessionDataProviderKeys {
  static const _token = '';
}

class SessionDataProvider {
  final _sharedPreferences = SharedPreferences.getInstance();

  Future<String?> token() async {
    return (await _sharedPreferences)
        .getString(SessionDataProviderKeys._token);
  }

  Future<void> saveToken(String token) async {
    (await _sharedPreferences).setString(SessionDataProviderKeys._token, token);
  }

  Future<void> clearToken() async {
    (await _sharedPreferences).remove(SessionDataProviderKeys._token);
  }
}
