import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/shared/persistence/database.dart';

class TravelExpense {
  final String id;
  final String description;
  final String travelDayId;
  final Money amount;

  TravelExpense({String? id, required this.description, required this.travelDayId, required this.amount}) : this.id = id ?? Database.instance.createId();
}