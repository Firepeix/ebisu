import 'package:ebisu/ui_components/chronos/controllers/date_controller.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:flutter/material.dart';

class DateInput extends StatelessWidget {
  final String? label;
  final String? hint;
  final bool dense;
  final FormFieldSetter<DateTime>? onSaved;
  final FormFieldValidator<DateTime>? validator;

  const DateInput({Key? key, this.label, this.hint, this.onSaved, this.validator, this.dense = false}) : super(key: key);

  DateTime? date(String? value) {
    return DateTime.tryParse(value?.split("/").reversed.join("-") ?? "");
  }

  @override
  Widget build(BuildContext context) => Input(
    keyboardType: TextInputType.number,
    label: label,
    hint: hint,
    dense: dense,
    controller: DateController(),
    validator: (value) => validator?.call(date(value)),
    onSaved: (value) => onSaved?.call(date(value)),
  );
}