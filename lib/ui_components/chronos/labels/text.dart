import 'package:flutter/material.dart';

import '../colors/colors.dart';

class NormalText extends StatelessWidget {
  final String text;
  const NormalText({Key? key, required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
        color: EColor.black
    ),
    maxLines: 1,
    overflow: TextOverflow.ellipsis,
  );
}