import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:flutter/material.dart';

class Label extends StatelessWidget {
  final String text;
  final Color? accent;
  const Label({Key? key, required this.text, this.accent = EColor.accent}) : super(key: key);
  const Label.main({Key? key, required this.text, this.accent = EColor.main}) : super(key: key);


  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontWeight: FontWeight.w700,
      color: accent
    ),
  );
}
