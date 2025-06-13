import 'package:flutter/material.dart';

class ErrorSnackbar extends SnackBar {
  ErrorSnackbar({super.key, required String message})
    : super(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
}

class WarningSnackbar extends SnackBar {
  WarningSnackbar({super.key, required String message})
    : super(
        content: Text(message),
        backgroundColor: Colors.orange.shade300,
        duration: Duration(seconds: 4),
      );
}

class SuccessSnackbar extends SnackBar {
  SuccessSnackbar({super.key, required String message})
    : super(
        content: Text(message),
        // backgroundColor: Colors.red,
        duration: Duration(seconds: 4),
      );
}
