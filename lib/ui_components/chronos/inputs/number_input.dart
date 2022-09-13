import 'package:ebisu/src/UI/Components/Form/InputFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class NumberInput extends StatelessWidget  {
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final int? maxLength;
  final ValueChanged<int?>? onChanged;
  final FormFieldSetter<int>? onSaved;
  final String? label;
  final String? hint;

  NumberInput({
    this.label,
    this.hint,
    this.validator,
    this.maxLength,
    this.decoration,
    this.onChanged,
    this.onSaved
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onSaved: (value) => onSaved!(value != null ? int.tryParse(value) : null),
      onChanged: (value) => onChanged!(int.tryParse(value)),
      validator: validator,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      inputFormatters: [NumbersOnlyFormatter()],
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
          border: const OutlineInputBorder(),
          hintText: hint ?? '',
          labelText: label ?? '',
          errorStyle: const TextStyle(fontSize: 16),
          isDense: true,
          contentPadding: EdgeInsets.fromLTRB(12, 20, 12, 12)
      ),
    );
  }
}
