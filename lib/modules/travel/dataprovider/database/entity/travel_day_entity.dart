import 'package:ebisu/shared/http/request.dart';

class TravelDayEntity {
  String id;
  String date;
  int budget;

  TravelDayEntity({required this.id, required this.date, required this.budget});

  Json toJson() => {
    "id": id,
    "date": date,
    "budget": budget
  };

  static List<TravelDayEntity> fromJson(List<dynamic> json) {
    return json.map((e) {
      return TravelDayEntity(
          id: e["id"],
          date: e["date"],
          budget: e["budget"]
      );
    }).toList();
  }
}