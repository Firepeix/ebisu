import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/ui_components/chronos/inputs/select_input.dart';
import 'package:flutter/material.dart';

@immutable
class ExpenseSourceModel implements CanBePutInSelectBox, HasSubtitlesInSelectBox {
  final String id;
  final String name;
  final ExpenseSourceType type;

  ExpenseSourceModel(this.id, this.name, this.type);

  @override
  Color? selectBoxColor() => null;

  @override
  String selectBoxLabel() => name;

  @override
  String selectBoxSubtitles() => type.title;
}