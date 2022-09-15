import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/ui_components/chronos/inputs/select_input.dart';
import 'package:flutter/material.dart';

@immutable
class EstablishmentModel extends ExpenseSourceModel implements CanBePutInSelectBox {
  EstablishmentModel(id, name) : super(id, name, ExpenseSourceType.ESTABLISHMENT);

  @override
  Color? selectBoxColor() => null;

  @override
  String selectBoxLabel() => name;

  @override
  bool operator ==(Object other) {
    if (other is EstablishmentModel) {
      return id == other.id;
    }

    return false;
  }

  @override
  int get hashCode {
    return id.hashCode;
  }
}
