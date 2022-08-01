import 'package:hive/hive.dart';

part 'travel_expense_model.g.dart';

@HiveType(typeId: 6)
class TravelExpenseModel extends HiveObject {
  @HiveField(0)
  String id;

  @HiveField(1)
  String description;

  @HiveField(2)
  int amount;

  @HiveField(3)
  String travelDayId;

  TravelExpenseModel(this.id, this.description, this.amount, this.travelDayId);
}