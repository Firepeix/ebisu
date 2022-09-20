import 'package:ebisu/modules/card/models/card.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class CardMapper {
  CardModel fromJson(Map<dynamic, dynamic> json) {
    final rgb = json["color"];
    return CardModel(
        id: json["id"],
        name: json["name"],
        budget: json["budget"],
        color: Color.fromARGB(255, rgb["red"], rgb["green"], rgb["blue"]),
        dueDate: json["due_date"] != null ? DateTime.parse(json["due_date"]) : null,
        closeDate: json["close_date"] != null ? DateTime.parse(json["close_date"]) : null,
    );
  }

  List<CardModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }

  Map<dynamic, dynamic> toCreateExpenseJson(CardModel cardModel) {
    return { "id": cardModel.id };
  }
}