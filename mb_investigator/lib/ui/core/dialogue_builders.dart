import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class DialogueBuilders {
  static Future<void> showExecptionDialog(
      BuildContext context, String title, String text, Object ex) {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Column(
            children: [
              Text(text),
              const Padding(padding: EdgeInsets.only(top: 10)),
              ExpandablePanel(
                header: const Text(
                  "Exception details:",
                  textAlign: TextAlign.right,
                  style: TextStyle(color: Colors.white54),
                ),
                collapsed: const Text(""),
                expanded: Text(
                  "$ex",
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                textStyle: Theme.of(context).textTheme.labelLarge,
              ),
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
