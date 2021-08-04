import 'package:ebisu/shared/Domain/ValueObjects.dart';
import 'package:flutter/material.dart';

class Card {

}

class CardType extends StringValueObject {
  final colors = {
    'Nubank': Colors.purple,
    'Meliuz': Colors.blueAccent,
    'Picpay': Colors.green,
  };

  CardType(String value) : super(value);

  String get title {
    return value[0].toUpperCase() + value.substring(1).toLowerCase();
  }

  Color get color {
    final color = colors[title];
    return color ?? Colors.black;
  }
}

enum CardClass {
  DEBIT,
  CREDIT
}