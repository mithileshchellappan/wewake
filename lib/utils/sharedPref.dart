import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesHelper {
  static SharedPreferences? _preferences;

  static Future<SharedPreferences> get preferences async {
    _preferences ??= await SharedPreferences.getInstance();
    return _preferences!;
  }

  static Future<bool> containsKey(String key) async {
    final prefs = await preferences;
    return prefs.containsKey(key);
  }

  static Future<void> setString(String key, String value) async {
    final prefs = await preferences;
    await prefs.setString(key, value);
  }

  static Future<String?> getString(String key) async {
    final prefs = await preferences;
    return prefs.getString(key);
  }

  static Future<void> setBool(String key, bool value) async {
    final prefs = await preferences;
    await prefs.setBool(key, value);
  }

  static Future<bool?> getBool(String key) async {
    final prefs = await preferences;
    return prefs.getBool(key);
  }

  static Future<void> setInt(String key, int value) async {
    final prefs = await preferences;
    await prefs.setInt(key, value);
  }

  static Future<int?> getInt(String key) async {
    final prefs = await preferences;
    return prefs.getInt(key);
  }

  static Future<void> setDouble(String key, double value) async {
    final prefs = await preferences;
    await prefs.setDouble(key, value);
  }

  static Future<double?> getDouble(String key) async {
    final prefs = await preferences;
    return prefs.getDouble(key);
  }

  static Future<void> setStringList(String key, List<String> value) async {
    final prefs = await preferences;
    await prefs.setStringList(key, value);
  }

  static Future<List<String>?> getStringList(String key) async {
    final prefs = await preferences;
    return prefs.getStringList(key);
  }

  static Future<void> remove(String key) async {
    final prefs = await preferences;
    await prefs.remove(key);
  }

  static Future<void> clear() async {
    final prefs = await preferences;
    await prefs.clear();
  }
}
