import 'package:sectec30/config/constants/constants.dart';
import 'package:flutter/material.dart';

class NotifyUI {
  static Future<void> showBasic(
      BuildContext context, String title, String message) {
    Widget continueButton = TextButton(
        onPressed: () => Navigator.pop(context),
        child: const Text('Aceptar', style: TextStyle(color: primaryColor)));

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      title: Text(
        title,
        style: const TextStyle(fontSize: 18),
      ),
      content:
          Text(message, style: const TextStyle(fontSize: 13, color: black21)),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
