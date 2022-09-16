import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
import 'package:flutter/material.dart';

@immutable
class CardModel implements CanBePutInSelectBox{
  final String id;
  final String name;
  final Color color;

  CardModel(this.id, this.name, this.color);

  @override
  Color? selectBoxColor() {
    return color;
  }

  @override
  String selectBoxLabel() {
    return name;
  }

  @override
  bool operator ==(Object other) {
    if (other is CardModel) {
      return name == other.name && color.value == other.color.value;
    }

    return false;
  }

  @override
  int get hashCode {
    return name.hashCode + color.hashCode;
  }
}
