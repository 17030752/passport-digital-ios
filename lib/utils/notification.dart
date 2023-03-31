import 'package:flutter/material.dart';

Future<void> showDialogNotification(BuildContext context, String title,
    String content, IconData icon, Color color) async {
  return showDialog<void>(
    context: context,
    barrierDismissible: false, // user must tap button!
    builder: (BuildContext context) {
      return AlertDialog(
        icon: Align(
          alignment: Alignment.topRight,
          child: Icon(
            icon,
            color: color,
            size: 25,
          ),
        ),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Align(
          alignment: Alignment.topLeft,
          child: Text(title),
        ),
        content: SingleChildScrollView(
          child: ListBody(
            children: <Widget>[
              Text(content),
            ],
          ),
        ),
        actions: <Widget>[
          TextButton(
            child: const Text('Entendido !'),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
