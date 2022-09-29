import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
import 'package:flutter/material.dart';

@immutable
class EstablishmentModel extends ExpenseSourceModel implements CanBePutInSelectBox {
  EstablishmentModel(id, name) : super(id, name, ExpenseSourceType.ESTABLISHMENT);

  @override
  Color? selectBoxColor() => null;

  @override
  String selectBoxLabel() => name;
}
