import 'package:flutter/material.dart';

class SnackbarUtils {
  static void showSuccess(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.greenAccent,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static void showError(BuildContext context, String message) {
    final snackBar = SnackBar(
      content: Text(
        message,
        style: const TextStyle(color: Colors.black),
      ),
      backgroundColor: Colors.red,
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
