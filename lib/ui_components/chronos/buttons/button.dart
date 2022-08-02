import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  final VoidCallback? onPressed;
  final String? text;
  final Size? minimumSize;
  final bool fit;
  final bool invert;
  final bool wide;

  const Button({
    Key? key,
    required this.onPressed,
    this.text,
    this.minimumSize,
    this.fit = false,
    this.invert = false,
    this.wide = false
  }) :  assert(!wide || wide && minimumSize == null, "Se voce declarar o tamanho como Wide, não pode ter especificado outro tamanho"),
        assert(!fit || fit && minimumSize == null, "Se voce declarar para o botão expandir, não pode ter especificado outro tamanho"),
        super(key: key);


  @override
  Widget build(BuildContext context) => fit == true ? full(context) : button(context);

  Widget button(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return ElevatedButton(
        onPressed: onPressed,
        style: ElevatedButton.styleFrom(
          primary: !invert ? colors.primary : Colors.white,
          minimumSize: wide ? Size(120, 36) : minimumSize,
          onPrimary: !invert ? Colors.white : colors.primary
        ),
        child: Text(text ?? "")
    );
  }

  Widget full(BuildContext context) => Expanded(child: button(context), flex: 1,);
}
