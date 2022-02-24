import 'package:ebisu/ui_components/chronos/colors/colors.dart';
import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Size? minimumSize;
  final bool? fit;

  const Button({Key? key, required this.onPressed, this.text, this.minimumSize, this.fit}) : super(key: key);

  const Button.wide({Key? key, required this.onPressed, this.text, this.minimumSize = const Size(190, 36), this.fit}) : super(key: key);

  const Button.fit({Key? key, required this.onPressed, this.text, this.fit = true, this.minimumSize}) : super(key: key);


  @override
  Widget build(BuildContext context) => fit == true ? full(context) : button(context);

  Widget button(BuildContext context) => ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(primary: EColor.accent, minimumSize: minimumSize),
      child: Text(text ?? "")
  );

  Widget full(BuildContext context) => Expanded(child: button(context), flex: 1,);
}
