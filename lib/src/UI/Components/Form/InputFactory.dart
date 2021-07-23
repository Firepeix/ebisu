import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'InputFormatter.dart';

class RadioInput extends StatelessWidget {
  final int? groupValue;
  final String label;
  final int value;
  final ValueChanged<int?> onChanged;

  RadioInput({required this.groupValue, required this.label, required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          height: 20,
          child: Radio (
            value: value,
            groupValue: groupValue,
            onChanged: onChanged,
          ),
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

class RadioGroup extends FormField  {
  final List<RadioInput> children;

  RadioGroup({required this.children, FormFieldValidator? validator}) :
        super(builder: (FormFieldState state) => build(children, state), validator: validator);

  static Widget build(List<RadioInput> children, FormFieldState state) {
    return Column(
      children: [
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: children
        ),
        AnimatedOpacity(
            opacity: state.hasError ? 1 : 0,
            duration:  Duration(milliseconds: 400),
            child: AnimatedContainer(
              duration: Duration(milliseconds: 100),
              height: state.hasError ? 20 : 0,
              child: Padding(
                padding: EdgeInsets.only(top: 5),
                child: Text(state.errorText ?? '', style: TextStyle(fontSize: 16, color: Color(0xFFD32332))),
              ),
            )
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
  final FormFieldValidator<String>? validator;
  SelectInput({required this.items, required this.value, required this.onChanged, this.style, this.decoration, this.validator});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: DropdownButtonFormField<String>(
              value: value,
              validator: validator,
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