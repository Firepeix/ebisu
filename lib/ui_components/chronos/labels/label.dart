import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:flutter/material.dart';

enum LabelMode {
  ACTIVE,
  NORMAL
}

class Label extends StatelessWidget {
  final String text;
  final Color? accent;
  final double? size;
  final LabelMode mode;

  const Label({Key? key, required this.text, this.accent = EColor.main, this.size, this.mode = LabelMode.ACTIVE}) : super(key: key);
  const Label.accent({Key? key, required this.text, this.accent = EColor.accent, this.size, this.mode = LabelMode.ACTIVE}) : super(key: key);


  @override
  Widget build(BuildContext context) => Text(
    text,
    style: TextStyle(
      fontSize: size,
      fontWeight: FontWeight.w700,
      color: mode == LabelMode.ACTIVE ? accent : EColor.grey
    ),
  );
}
