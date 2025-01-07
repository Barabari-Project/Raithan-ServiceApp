
import 'package:shared_preferences/shared_preferences.dart';

class Storage{

  static Future<void> saveValue(String key,String value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(key, value);
  }

  static Future<String?> getValue(String key) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(key);
  }

  static Future<void> removeAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // This removes all stored key-value pairs
  }

}