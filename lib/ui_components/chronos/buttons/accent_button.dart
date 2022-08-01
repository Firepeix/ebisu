import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:flutter/material.dart';

import 'abstract_button.dart';

class AccentButton extends StatelessAbstractButton {
  final String? text;
  final IconData? icon;

  const AccentButton({Key? key, required VoidCallback onPressed, this.text, this.icon}) : super(key: key, onPressed: onPressed);

  @override
  Widget build(BuildContext context) => ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: EColor.main, minimumSize: const Size(0, 25)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(padding: const EdgeInsets.only(left: 10), child: Text(text ?? "", style: const TextStyle(fontSize: 13),),),
          Icon(icon)
        ],
      ),
  );

}
