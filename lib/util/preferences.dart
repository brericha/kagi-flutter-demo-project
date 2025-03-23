import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// App preferences helper. [init] should be called early (in bootstrap.dart).
/// Trying to use any function before calling [init] will cause an exception
/// as the SharedPreferences object will not have been set up.
class Preferences {
  late SharedPreferencesWithCache _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferencesWithCache.create(
      cacheOptions: const SharedPreferencesWithCacheOptions(),
    );
  }

  /// Enabled categories and the order to display them in
  String get _categories => 'categories';

  /// Default list of categories
  List<String> get _defaultCategories => [
    'World',
    'Business',
    'Technology',
    'Science',
    'Sports',
    'Today in History',
  ];

  List<String> get categories =>
      _prefs.getStringList(_categories) ?? _defaultCategories;
  set categories(List<String> value) =>
      _prefs.setStringList(_categories, value);

  String get _themeMode => 'themeMode';
  ThemeMode get themeMode {
    switch (_prefs.getString(_themeMode) ?? 'system') {
      case 'light':
        return ThemeMode.light;
      case 'dark':
        return ThemeMode.dark;
      default:
        return ThemeMode.system;
    }
  }

  set themeMode(ThemeMode value) {
    switch (value) {
      case ThemeMode.dark:
        _prefs.setString(_themeMode, 'dark');
      case ThemeMode.light:
        _prefs.setString(_themeMode, 'light');
      case ThemeMode.system:
        _prefs.setString(_themeMode, 'system');
    }
  }

  String get _readStories => 'readStories';
  Map<String, DateTime> get readStories {
    final data = _prefs.getString(_readStories);
    if (data == null) {
      return {};
    } else {
      final json = jsonDecode(data) as Map<String, dynamic>;
      return json.map(
        (key, value) => MapEntry(key, DateTime.parse(value.toString())),
      );
    }
  }

  set readStories(Map<String, DateTime> values) {
    final json = values.map(
      (key, value) => MapEntry(key, value.toIso8601String()),
    );
    _prefs.setString(_readStories, jsonEncode(json));
  }

  String get _numStoriesRead => 'numStoriesRead';
  int get numStoriesRead => _prefs.getInt(_numStoriesRead) ?? 0;
  set numStoriesRead(int value) => _prefs.setInt(_numStoriesRead, value);
}
