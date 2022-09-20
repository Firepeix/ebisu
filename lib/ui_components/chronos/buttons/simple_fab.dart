import 'package:ebisu/ui_components/chronos/buttons/abstract_button.dart';
import 'package:flutter/material.dart';

class SimpleFAB extends StatelessAbstractButton {
  final IconData? icon;
  final String? tooltip;

  const SimpleFAB(onPressed, {Key? key, this.icon, this.tooltip}) : super(key: key, onPressed: onPressed);

  const SimpleFAB.save(onPressed, {Key? key}) : this(key: key, onPressed, icon: Icons.check, tooltip: "Salvar");

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: tooltip,
      child: icon != null ? Icon(icon, size: 30,) : null,
    );
  }
}
