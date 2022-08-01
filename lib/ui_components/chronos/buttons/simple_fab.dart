import 'package:ebisu/ui_components/chronos/buttons/abstract_button.dart';
import 'package:flutter/material.dart';

class SimpleFAB extends StatelessAbstractButton {
  final IconData? icon;

  const SimpleFAB(onPressed, {Key? key, this.icon}) : super(key: key, onPressed: onPressed);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      child: icon != null ? Icon(icon, size: 30,) : null,
    );
  }
}
