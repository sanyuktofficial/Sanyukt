import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class NotificationService {
  static void showSuccess(String message) {
    _show(message, backgroundColor: Colors.green.shade700);
  }

  static void showError(String message) {
    _show(message, backgroundColor: Colors.red.shade700);
  }

  static void showInfo(String message) {
    _show(message, backgroundColor: Colors.blueGrey.shade700);
  }

  static void _show(
    String message, {
    required Color backgroundColor,
  }) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      backgroundColor: backgroundColor,
      textColor: Colors.white,
      fontSize: 14,
    );
  }
}

