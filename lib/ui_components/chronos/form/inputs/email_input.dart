import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:flutter/material.dart';

class EmailInput extends StatelessWidget {
  const EmailInput({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const Input(
    label: "Email",
  );
}