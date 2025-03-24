import 'package:flutter/material.dart';

class SettingsGroupWidget extends StatelessWidget {
  const SettingsGroupWidget(
      {super.key, required this.groupeName, required this.children});

  final String groupeName;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          groupeName,
          style: DefaultTextStyle.of(context).style.apply(fontSizeFactor: 2.0),
        ),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Wrap(
              runSpacing: 15.0,
              alignment: WrapAlignment.spaceBetween,
              spacing: 15.0,
              children: children,
            ),
          ),
        ),
      ],
    );
  }
}
