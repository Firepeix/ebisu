import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Icon? icon;
  final Size? minimumSize;
  final Color? backgroundColor;
  final Color? foregroundColor;
  final bool fit;
  final bool invert;
  final bool wide;

  const Button(
      {Key? key,
      required this.onPressed,
      this.text,
      this.icon,
      this.backgroundColor,
      this.foregroundColor,
      this.minimumSize,
      this.fit = false,
      this.invert = false,
      this.wide = false})
      : assert(!wide || wide && minimumSize == null,
            "Se voce declarar o tamanho como Wide, não pode ter especificado outro tamanho"),
        assert(!fit || fit && minimumSize == null,
            "Se voce declarar para o botão expandir, não pode ter especificado outro tamanho"),
        super(key: key);

  @override
  Widget build(BuildContext context) => fit == true ? full(context) : button(context);

  Widget button(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    final backgroundColor = this.backgroundColor ?? colors.primary;
    final foregroundColor = this.foregroundColor ?? colors.primary;

    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
            backgroundColor: !invert ? backgroundColor : Colors.white,
            minimumSize: wide ? Size(120, 36) : minimumSize,
            foregroundColor: !invert ? Colors.white : foregroundColor),
        child: icon == null
            ? Text(text ?? "")
            : Row(
                children: [icon!, Padding(padding: EdgeInsets.symmetric(horizontal: 13), child: Text(text ?? ""),)],
              ));
  }

  Widget full(BuildContext context) => Expanded(
        child: button(context),
        flex: 1,
      );
}
