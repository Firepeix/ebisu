import 'package:flutter/material.dart';

import '../colors/colors.dart';

class Title extends StatelessWidget {
  final String text;
  final double? size;

  const Title({Key? key, required this.text, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
        fontWeight: FontWeight.w900,
        fontSize: size ?? 20,
        color: EColor.black
    ),
  );
}

class ETitle extends StatelessWidget {
  final String text;
  final double? size;
  const ETitle(this.text, {Key? key, this.size}) : super(key: key);

  @override
  Widget build(BuildContext context) => Title(text: text, size: size,);
}