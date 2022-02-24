import 'package:flutter/material.dart';

class Input extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool dense;

  const Input({Key? key, this.label, this.hint, this.dense = false}) : super(key: key);

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
  );
}