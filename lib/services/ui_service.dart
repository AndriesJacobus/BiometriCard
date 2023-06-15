import 'package:flutter/material.dart';

class UiService {
  void closePopup(context) {
    Navigator.pop(context);
  }

  Future<void> showConfirmPopup(
    context,
    String title,
    String content,
    String confirmMessage, {
    bool popTwice = true,
    Color confirmColor = Colors.red,
  }) {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(child: Text(title)),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.black),
              ),
            ),
            TextButton(
              child: Text(
                confirmMessage,
                style: TextStyle(color: confirmColor),
              ),
              onPressed: () {
                closePopup(context);
                if (popTwice) {
                  closePopup(context);
                }
              },
            ),
          ],
          actionsAlignment: MainAxisAlignment.spaceEvenly,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(
              Radius.circular(16.0),
            ),
          ),
        );
      },
    );
  }
}
