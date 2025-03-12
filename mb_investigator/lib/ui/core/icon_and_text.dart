import 'package:flutter/material.dart';

class IconAndText extends StatelessWidget {
  const IconAndText({super.key, required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon),
        const Padding(padding: EdgeInsets.only(left: 5)),
        Text(
          text,
          style: const TextStyle(overflow: TextOverflow.ellipsis),
        )
      ],
    );
  }
}
