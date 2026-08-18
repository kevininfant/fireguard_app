import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fireguard_app/features/settings/data/models/settings_model.dart';

class SettingsRepository {
  static const String _settingsKey = 'fireguard_settings_pref';

  Future<SettingsModel> getSettings() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString(_settingsKey);
    if (data != null) {
      try {
        return SettingsModel.fromJson(jsonDecode(data));
      } catch (_) {}
    }
    const defaultSettings = SettingsModel();
    await saveSettings(defaultSettings);
    return defaultSettings;
  }

  Future<void> saveSettings(SettingsModel settings) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_settingsKey, jsonEncode(settings.toJson()));
  }
}
