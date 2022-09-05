import 'package:ebisu/card/models/card.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class CardMapper {
  ExpenseCard fromJson(Map<dynamic, dynamic> json) {
    final rgb = json["color"];
    return ExpenseCard(
        json["name"],
        Color.fromARGB(255, rgb["red"], rgb["green"], rgb["blue"])
    );
  }
}