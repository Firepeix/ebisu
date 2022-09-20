import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
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

  @override
  bool operator ==(Object other) {
    if (other is ExpenseSourceModel) {
      return other.id == id && type == other.type;
    }
    return false;
  }

  @override
  int get hashCode {
    return id.hashCode + type.hashCode;
  }
}