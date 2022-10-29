import 'dart:ui';

import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';

class UserModel extends ExpenseSourceModel implements CanBePutInSelectBox {
  UserModel(id, name) : super(id, name, ExpenseSourceType.USER);

  @override
  Color? selectBoxColor() {
    return null;
  }

  @override
  String selectBoxLabel() {
    return name;
  }
}