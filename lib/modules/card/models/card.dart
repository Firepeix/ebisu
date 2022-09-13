import 'package:ebisu/ui_components/chronos/inputs/select_input.dart';
import 'package:flutter/material.dart';

@immutable
class ExpenseCard implements CanBePutInSelectBox{
  final String name;
  final Color color;

  ExpenseCard(this.name, this.color);

  @override
  Color? selectBoxColor() {
    return color;
  }

  @override
  String selectBoxLabel() {
    return name;
  }
}
