import 'package:shared_preferences/shared_preferences.dart';

abstract class PersistedRepository {
  Future<String?> read(String uniqueKey) async {
    SharedPreferences? prefs = await SharedPreferences.getInstance();

    String? stored;

    try {
      stored = prefs.getString(uniqueKey);
      //property = dynamic.fromJson(json.decode(storedProperty));

    } catch (e) {
      return null;
    }

    return stored;
  }

  Future write(String json, String uniqueKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    await prefs.setString(uniqueKey, json);
  }

  static Future remove(String uniqueKey) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    final keys = prefs.getKeys().where((e) => e.contains('property'));

    keys.forEach((e) {
      prefs.remove(e);
    });
  }
}
