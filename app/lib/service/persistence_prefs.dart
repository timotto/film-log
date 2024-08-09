import 'package:film_log/service/persistence.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesPersistence implements Persistence {
  late SharedPreferences _prefs;

  Future<void> setup() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  Future<void> delete(String key) async {
    await _prefs.remove(key);
  }

  @override
  Future<String?> get(String key) async => _prefs.getString(key);

  @override
  Future<void> set(String key, String value) async {
    await _prefs.setString(key, value);
  }
}