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
  final int? initialValue;
  final Key? inputKey;

  NumberInput({
    this.label,
    this.hint,
    this.validator,
    this.maxLength,
    this.decoration,
    this.onChanged,
    this.onSaved,
    this.inputKey,
    this.initialValue,
  }) : assert(!(onChanged == null && onSaved == null), "Você deve colocar ou quando muda o valor ou quando ele é salvo");

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      key: inputKey,
      initialValue: initialValue == 0 ? "" : initialValue.toString(),
      onSaved: (value) => onSaved?.call(value != null ? int.tryParse(value) : null),
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
