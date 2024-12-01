import 'dart:async';

import 'package:flutter/material.dart';

import '../models/user.dart';
import '../services/user.dart';

abstract class BaseComponent<T extends StatefulWidget> extends State<T> {
  late StreamSubscription<String> _languageChangeSubscription;
  late UserModel? _currentUser;
  late StreamSubscription _userChangeSubscription;
  late bool _isLoading;

  IUserService get _userService => UserService();

  @override
  void initState() {
    super.initState();
    _isLoading = true;

    _initializeCurrentUser();
  }

  Future<void> _initializeCurrentUser() async {
    _currentUser = await _userService.currentUser;

    _userChangeSubscription = _userService.onUserChanged.listen((user) {
      setState(() {
        _currentUser = user;
      });
    });

    initializeComponentState();
  }

  Future<void> initializeComponentState() async {
    setState(() {
      _isLoading = false;
    });
  }

  Widget buildLoadingIndicator() {
    return Container(
      color: Colors.white,
      child: const Center(
        child: CircularProgressIndicator(
          color: Colors.cyan,
        ),
      ),
    );
  }

  UserModel? get currentUser => _currentUser;

  IUserService get userService => _userService;

  bool get isLoading => _isLoading;

  set isLoading(isLoading) => _isLoading = isLoading;

  @override
  void dispose() {
    _languageChangeSubscription.cancel();
    _userChangeSubscription.cancel();
    super.dispose();
  }
}
