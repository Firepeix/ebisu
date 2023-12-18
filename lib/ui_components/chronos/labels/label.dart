import 'package:ebisu/modules/user/entry/component/user_context.dart';
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
  final bool isAccent;

  const Label({Key? key, required this.text, this.accent, this.size, this.mode = LabelMode.ACTIVE, this.isAccent = false}) : super(key: key);
  const Label.accent({Key? key, required this.text, this.accent, this.size, this.mode = LabelMode.ACTIVE, this.isAccent = true}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    final userContext = UserContext.of(context);
    final color = isAccent ? userContext.theme.colorScheme.secondary : userContext.theme.primaryColor;

    return Text(
      text,
      style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.w700,
          color: mode == LabelMode.ACTIVE ? color : (accent ?? EColor.grey)
      ),
    );
  }
}
