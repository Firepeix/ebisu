import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
import 'package:flutter/material.dart';

@immutable
class CardModel implements CanBePutInSelectBox, SaveCardModel {
  final String id;
  final List<CardModel> sisters;

  final String name;
  @override
  String getName() => name;

  final Color color;

  Color getColor() => color;

  final int budget;
  @override
  int getBudget() => budget;

  final DateTime? dueDate;

  @override
  DateTime? getDueDate() => dueDate;

  final DateTime? closeDate;
  @override
  DateTime? getCloseDate() => closeDate;

  CardModel(
      {required this.id,
      required this.name,
      required this.color,
      required this.budget,
      this.dueDate,
      this.closeDate,
      List<CardModel>? sisters})
      : this.sisters = sisters ?? [];

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

  bool get isShared {
    return sisters.isNotEmpty;
  }

  int get sharedAmount {
    return isShared ? sisters.length + 1 : 0;
  }
}
