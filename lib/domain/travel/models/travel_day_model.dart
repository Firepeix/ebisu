import 'package:hive/hive.dart';

part 'travel_day_model.g.dart';

@HiveType(typeId: 5)
class TravelDayModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String date;

  @HiveField(2)
  int budget;

  TravelDayModel(this.id, this.date, this.budget);
}