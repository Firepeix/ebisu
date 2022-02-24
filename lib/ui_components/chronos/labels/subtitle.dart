import 'package:flutter/material.dart';

import '../colors/colors.dart';

class Subtitle extends StatelessWidget {
  final String text;
  const Subtitle({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        color: EColor.grey
    ),
  );
}