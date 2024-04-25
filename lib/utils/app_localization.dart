import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations({required this.locale});

  static String _languageCode = "en";
  static Map<String, String> _localizedString = {};

  static Future<void> load() async {
    String jsonStr = await rootBundle.loadString("assets/$_languageCode.json");

    Map<String, dynamic> jsonMap = jsonDecode(jsonStr);

    _localizedString =
        jsonMap.map((key, value) => MapEntry(key, value.toString()));
  }

  static Future<void> setLanguageCode({required String langCode}) async {
    _languageCode = langCode;

    await load();
  }

  static String translate(String key) {
    return _localizedString[key] ?? "";
  }
}
