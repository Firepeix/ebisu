import 'package:ebisu/modules/card/models/card.dart';
import 'package:flutter/material.dart';
import 'package:injectable/injectable.dart';

@injectable
class CardMapper {
  CardModel fromJson(Map<dynamic, dynamic> json) {
    final rgb = json["color"];
    return CardModel(
        json["id"],
        json["name"],
        Color.fromARGB(255, rgb["red"], rgb["green"], rgb["blue"])
    );
  }

  List<CardModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }

  Map<dynamic, dynamic> toCreateExpenseJson(CardModel cardModel) {
    return { "id": cardModel.id };
  }
}