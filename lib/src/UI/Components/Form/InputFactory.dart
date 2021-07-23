import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'InputFormatter.dart';

class RadioInput extends StatelessWidget {
  final String? groupValue;
  final String label;
  final String value;
  final ValueChanged<String?> onChanged;

  RadioInput({required this.groupValue, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Radio (
          value: value,
          groupValue: groupValue,
          onChanged: onChanged,
        ),
        InkWell(
          highlightColor: Colors.transparent,
          splashColor: Colors.transparent,
          child: Text(label, style: TextStyle(fontSize: 16.0)),
          onTap: () => {
            onChanged(value)
          },
        )
      ],
    );
  }
}

class RadioGroup extends StatelessWidget  {
  final List<RadioInput> children;

  RadioGroup({required this.children});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children
        )
      ],
    );
  }
}

class SelectInput extends StatelessWidget  {
  final String? value;
  final ValueChanged<String?> onChanged;
  final TextStyle? style;
  final InputDecoration? decoration;
  final Map items;

  SelectInput({required this.items, required this.value, required this.onChanged, this.style, this.decoration});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              icon: Icon(Icons.arrow_downward_rounded),
              isDense: true,
              decoration: decoration,
              onChanged: onChanged,
              items: items.entries.map((e) => DropdownMenuItem(value: e.key.toString(), child: Text(e.value[0] + e.value.substring(1).toLowerCase()))).toList(),
            )
        )
      ],
    );
  }
}

class NumberInput extends StatelessWidget  {
  final FormFieldValidator<String>? validator;
  final InputDecoration? decoration;
  final int? maxLength;

  NumberInput({
    this.validator,
    this.maxLength,
    this.decoration
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      validator: validator,
      maxLength: maxLength,
      maxLengthEnforcement: MaxLengthEnforcement.enforced,
      inputFormatters: [NumbersOnlyFormatter()],
      keyboardType: TextInputType.number,
      decoration: decoration,
    );
  }
}

class AmountInput extends StatelessWidget  {
  final FormFieldValidator<String>? validator;
  final InputFormDecorator decorator = InputFormDecorator();

  AmountInput({
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        maxLength: 8,
        textAlign: TextAlign.center,
        controller: MoneyMaskedTextController(),
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 76, fontWeight: FontWeight.w500),
        validator: validator,
        decoration: decorator.amountForm()
    );
  }
}