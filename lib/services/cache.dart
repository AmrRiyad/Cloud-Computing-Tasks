import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

abstract class ICacheService {
  Stream<String> get onLanguageChanged;

  Future<void> setLanguage(String language);

  Future<String> getLanguage();
}

class CacheService implements ICacheService {
  // Singleton instance
  static final CacheService _instance = CacheService._internal();

  // Factory constructor to return the singleton instance
  factory CacheService() {
    return _instance;
  }

  // Private named constructor
  CacheService._internal();

  // Stream controller for language change
  final StreamController<String> _languageChangeController =
      StreamController<String>.broadcast();

  // Language change stream
  @override
  Stream<String> get onLanguageChanged => _languageChangeController.stream;

  // Set the language preference and notify listeners
  @override
  Future<void> setLanguage(String language) async {
    (await SharedPreferences.getInstance()).setString('language', language);
    _languageChangeController.add(language);
  }

  // Get the current language preference
  @override
  Future<String> getLanguage() async {
    return (await SharedPreferences.getInstance()).getString('language') ??
        'English';
  }
}
