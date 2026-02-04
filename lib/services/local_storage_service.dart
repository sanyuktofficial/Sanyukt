import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageKeys {
  static const authToken = 'auth_token';
  static const userId = 'user_id';
  static const isGuest = 'is_guest';
}

class LocalStorageService {
  LocalStorageService._(this._prefs);

  final SharedPreferences _prefs;

  static Future<LocalStorageService> init() async {
    final prefs = await SharedPreferences.getInstance();
    return LocalStorageService._(prefs);
  }

  String? get authToken => _prefs.getString(LocalStorageKeys.authToken);

  Future<void> setAuthToken(String? token) async {
    if (token == null) {
      await _prefs.remove(LocalStorageKeys.authToken);
    } else {
      await _prefs.setString(LocalStorageKeys.authToken, token);
    }
  }

  String? get userId => _prefs.getString(LocalStorageKeys.userId);

  Future<void> setUserId(String? id) async {
    if (id == null) {
      await _prefs.remove(LocalStorageKeys.userId);
    } else {
      await _prefs.setString(LocalStorageKeys.userId, id);
    }
  }

  bool get isGuest => _prefs.getBool(LocalStorageKeys.isGuest) ?? false;

  Future<void> setIsGuest(bool value) async {
    await _prefs.setBool(LocalStorageKeys.isGuest, value);
  }

  Future<void> clear() async {
    await _prefs.remove(LocalStorageKeys.authToken);
    await _prefs.remove(LocalStorageKeys.userId);
    await _prefs.remove(LocalStorageKeys.isGuest);
  }
}

