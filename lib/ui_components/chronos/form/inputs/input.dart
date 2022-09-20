import 'package:ebisu/ui_components/chronos/controllers/controllers.dart';
import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool dense;
  final TextInputType? keyboardType;
  final Controller? controller;
  final FormFieldSetter<String>? onSaved;
  final FormFieldValidator<String>? validator;
  final ValueChanged<String?>? onChanged;
  final String? initialValue;

  const Input({
    Key? key,
    this.label,
    this.hint,
    this.keyboardType,
    this.controller,
    this.onSaved,
    this.validator,
    this.onChanged,
    this.initialValue,
    this.dense = false
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => TextFormField(
    decoration: InputDecoration(
        border: const OutlineInputBorder(),
        hintText: hint ?? '',
        labelText: label ?? '',
        errorStyle: const TextStyle(fontSize: 16),
        isDense: true,
        contentPadding: EdgeInsets.fromLTRB(12, !dense ? 20 : 20, 12, !dense ? 12 : 0)
    ),
    controller: controller?.getController(),
    initialValue: initialValue,
    onSaved: onSaved,
    validator: validator,
    onChanged: onChanged,
    keyboardType: keyboardType,
  );
}