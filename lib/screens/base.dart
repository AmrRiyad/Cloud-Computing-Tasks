import 'dart:async';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:cc_sa_1/services/cache.dart';
import 'package:cc_sa_1/services/toast.dart';
import 'package:cc_sa_1/services/user.dart';
import 'package:flutter/material.dart';


import '../shared/localization.dart';
import '../models/user.dart';

abstract class BaseScreen<T extends StatefulWidget> extends State<T> {
  late Locale _currentLocale;
  late Localization _localization;
  late StreamSubscription<String> _languageChangeSubscription;
  late UserModel? _currentUser;
  late StreamSubscription _userChangeSubscription;
  late bool _isLoading;

  IUserService get _userService => UserService();
  ICacheService get _cacheService => CacheService();
  IToastService get _toastService => ToastService();

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _initializeLocale();
    _initializeCurrentUser();
  }

  Future<void> _initializeLocale() async {
    _currentLocale =
        Locale(await _cacheService.getLanguage() == 'Arabic' ? 'ar' : 'en');
    _localization = Localization(_currentLocale);

    _languageChangeSubscription =
        _cacheService.onLanguageChanged.listen((language) {
          setState(() {
            _currentLocale = Locale(language == 'Arabic' ? 'ar' : 'en');
            _localization = Localization(_currentLocale);
          });
        });
  }

  Future<void> _initializeCurrentUser() async {
    _currentUser = await _userService.currentUser;

    _userChangeSubscription = _userService.onUserChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });
    });

    initializeScreenState();
  }

  Future<void> initializeScreenState() async {
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildLoadingIndicator() {
    bool isDark = AdaptiveTheme.of(context).mode.isDark;

    return Container(
      color: isDark ? Colors.black : Colors.white,
      child: Center(
        child: CircularProgressIndicator(
          color: isDark ? Colors.yellow.shade700 : Colors.yellow.shade800,
        ),
      ),
    );
  }

  Locale get currentLocale => _currentLocale;

  set currentLocale(currentLocale) => _currentLocale = currentLocale;

  Localization get localization => _localization;

  set localization(localization) => _localization = localization;

  UserModel? get currentUser => _currentUser;

  IUserService get userService => _userService;

  IToastService get toastService => _toastService;

  bool get isLoading => _isLoading;

  set isLoading(isLoading) => _isLoading = isLoading;

  @override
  void dispose() {
    _languageChangeSubscription.cancel();
    _userChangeSubscription.cancel();
    super.dispose();
  }
}
