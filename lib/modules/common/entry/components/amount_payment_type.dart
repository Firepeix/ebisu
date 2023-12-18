import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
import 'package:flutter/material.dart';

enum AmountPaymentType implements CanBePutInSelectBox {
  UNIT("Única"),
  FOREVER("Assinatura"),
  INSTALLMENT("Parcelada");

  final String label;

  const AmountPaymentType(this.label);

  String selectBoxLabel() {
    return label;
  }

  Color? selectBoxColor() {
    return null;
  }
}