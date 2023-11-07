import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../data/data.dart';

class SharedPreferencesService {
  static final SharedPreferencesService _instance =
      SharedPreferencesService._internal();
  factory SharedPreferencesService() => _instance;
  SharedPreferencesService._internal();

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _saveString(String key, String value) async {
    _prefs.setString(key, value);
  }

  Future<String?> _getString(String key) async {
    return _prefs.getString(key);
  }

  saveNamazVakitleri(NamazVakti namazVakti) async {
    final SharedPreferencesService prefsService = SharedPreferencesService();
    prefsService._saveString(
        'NamazVakti', jsonEncode(namazVakti.toJson()).toString());
  }

  Future<NamazVakti?> getNamazVakitleri() async {
    final SharedPreferencesService prefsService = SharedPreferencesService();
    final jsonString = await prefsService._getString('NamazVakti');
    if (jsonString == null) {
      return null;
    }

    try {
      final jsonMap = jsonDecode(jsonString);
      return NamazVakti.fromJson(jsonMap);
    } catch (e) {
      // debugPrint('Hata: $e');
      return null;
    }
  }
}
