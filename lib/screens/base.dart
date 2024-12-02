import 'dart:async';

import 'package:cc_sa_1/services/toast.dart';
import 'package:cc_sa_1/services/user.dart';
import 'package:flutter/material.dart';

import '../models/user.dart';

abstract class BaseScreen<T extends StatefulWidget> extends State<T> {
  late UserModel? _currentUser;
  late StreamSubscription _userChangeSubscription;
  late bool _isLoading;

  IUserService get _userService => UserService();
  IToastService get _toastService => ToastService();

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

    initializeScreenState();
  }

  Future<void> initializeScreenState() async {
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

  IToastService get toastService => _toastService;

  bool get isLoading => _isLoading;

  set isLoading(isLoading) => _isLoading = isLoading;

  @override
  void dispose() {
    _userChangeSubscription.cancel();
    super.dispose();
  }
}
