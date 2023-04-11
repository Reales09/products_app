import 'package:flutter/material.dart';

class NotificacionService {
  static GlobalKey<ScaffoldMessengerState> messengerKey =
      GlobalKey<ScaffoldMessengerState>();

  static showSnackbar(String message) {
    final snackbar = SnackBar(
      content: Text(message,
          style: TextStyle(
              color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold)),
      duration: Duration(milliseconds: 1500),
    );

    messengerKey.currentState!.showSnackBar(snackbar);
  }
}
