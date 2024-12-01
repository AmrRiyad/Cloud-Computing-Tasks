import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

abstract class IToastService {
  void showSuccessMessage(String message);

  void showErrorMessage(String message);
}

class ToastService implements IToastService {
  // Singleton instance
  static final ToastService _instance = ToastService._internal();

  // Private constructor
  ToastService._internal();

  // Factory constructor to return the singleton instance
  factory ToastService() {
    return _instance;
  }

  void _showToast(String message, Color backgroundColor) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 16.0,
    );
  }

  @override
  void showSuccessMessage(String message) {
    _showToast(message, Colors.green);
  }

  @override
  void showErrorMessage(String message) {
    _showToast(message, Colors.red);
  }
}
