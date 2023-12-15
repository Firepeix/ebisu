import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

class PasswordInput extends StatelessWidget {
  final bool hasForgotPassword;
  const PasswordInput({Key? key, this.hasForgotPassword = true}) : super(key: key);

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.end,
    children: const [
      Input(
          label: "Senha"
      ),
      Padding(
          padding: EdgeInsets.only(top: 7),
          child: Label.accent(text: "Esqueci minha senha"),
      )
    ],
  );
}