import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFormatter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class AmountInput extends StatelessWidget  {
  final FormFieldValidator<String>? validator;
  final InputFormDecorator decorator = InputFormDecorator();
  final ValueChanged<int?>? onChanged;
  final int? value;
  late final MoneyMaskedTextController controller;
  final FormFieldSetter<int>? onSaved;
  final bool? enabled;

  AmountInput({
    this.validator,
    this.value,
    this.onChanged,
    this.onSaved,
    this.enabled,
  }) {
    this.controller = MoneyMaskedTextController(initialValue: this.value != null ? this.value!.toDouble() / 100 : 0.0);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
        onSaved: (value) => onSaved!((controller.numberValue * 100).toInt()),
        onChanged: (value) => onChanged!((controller.numberValue * 100).toInt()),
        maxLength: 8,
        textAlign: TextAlign.center,
        controller: controller,
        enabled: enabled ?? true,
        maxLengthEnforcement: MaxLengthEnforcement.enforced,
        keyboardType: TextInputType.number,
        style: TextStyle(fontSize: 76, color: enabled == null || enabled! ? Colors.black : Colors.grey, fontWeight: FontWeight.w500),
        validator: validator,
        decoration: decorator.amountForm()
    );
  }
}