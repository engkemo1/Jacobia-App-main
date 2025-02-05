import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../view_model/database/local/cache_helper.dart';

class AppLocalization extends Translations {
  static Map<String, Map<String, String>> translations = {};

  /// Load localization JSON files dynamically
  static Future<void> loadTranslations() async {
    translations['en'] = await _loadJson('assets/lang/en.json');
    translations['ar'] = await _loadJson('assets/lang/ar.json');
  }

  /// Helper function to load JSON and convert it to Map<String, String>
  static Future<Map<String, String>> _loadJson(String path) async {
    String jsonString = await rootBundle.loadString(path);
    Map<String, dynamic> jsonMap = json.decode(jsonString);
    return jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  @override
  Map<String, Map<String, String>> get keys => translations;

  // Save language to CacheHelper
  static void saveLanguage(String languageCode) {
    CacheHelper.put(key: 'lan', value: languageCode);
  }

  // Load language from CacheHelper
  static String getSavedLanguage() {
    return CacheHelper.get(key: 'lan') ?? 'ar'; // Default to 'ar' if no language is saved
  }
}
