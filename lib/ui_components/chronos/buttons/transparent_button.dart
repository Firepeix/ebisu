import 'package:ebisu/ui_components/chronos/buttons/abstract_button.dart';
import 'package:flutter/material.dart';

class TransparentButton extends StatelessAbstractButton {
  final Widget child;
  const TransparentButton(onPressed, {required this.child, Key? key}) : super(key: key, onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onPressed,
        child: child,
      ),
      color: Colors.transparent,
    );
  }
}