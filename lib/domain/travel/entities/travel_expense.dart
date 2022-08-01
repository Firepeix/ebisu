import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';

class TravelExpense {
  final String description;
  final String travelDayId;
  final Money amount;
  late String id;

  TravelExpense(this.description, this.amount, this.travelDayId) {
    id = md5.convert(utf8.encode(description + amount.value.toString())).toString();
  }
}