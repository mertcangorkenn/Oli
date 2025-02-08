import 'package:shared_preferences/shared_preferences.dart';

class LocalStorage {
  static SharedPreferences? _preferences;

  LocalStorage._();
  static Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  static Future<void> setToken(String? accessToken) async {
    if (_preferences != null) {
      await _preferences!.setString('user_token', accessToken ?? '');
    }
  }

  static String getToken() {
    return _preferences?.getString('user_token') ?? '';
  }

  static void deleteToken() {
    _preferences?.remove('user_token');
  }

  static void logout() {
    deleteToken();
  }
}
