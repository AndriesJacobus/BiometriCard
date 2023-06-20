import 'package:biometricard/common/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';

class UiService {
  void closePopup(context) {
    Navigator.pop(context);
  }

  Future<void> showConfirmPopup(
    context,
    String title,
    String content,
    String confirmMessage, {
    bool showCancel = true,
    bool popTwice = true,
    Color confirmColor = Colors.red,
    Function? callback,
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
            if (showCancel)
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
                if (callback != null) {
                  callback();
                }

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

  void doToast(
    String message, {
    ToastGravity alignment = ToastGravity.BOTTOM,
    Toast length = Toast.LENGTH_SHORT,
    Color backgroundColor = AppColors.lightGreen,
    Color textColor = AppColors.persianBlue,
  }) {
    debugPrint("Yum, Toast!");

    Fluttertoast.showToast(
      msg: message,
      toastLength: length,
      gravity: alignment,
      timeInSecForIosWeb: 1,
      backgroundColor: backgroundColor,
      textColor: textColor,
      fontSize: 16.0,
    );
  }

  Future<void> copyValueToClipboard(String name, String value) async {
    debugPrint("Copying to clipboard...");
    // debugPrint("$name: $value");

    await Clipboard.setData(ClipboardData(text: value));

    // Show toast
    doToast("$name copied successfully!");
  }
}
