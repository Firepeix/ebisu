import 'package:hive/hive.dart';

part 'PurchaseModel.g.dart';

@HiveType(typeId : 3)
class PurchaseHiveModel extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  int total = 0;

  @HiveField(2)
  int value = 0;

  @HiveField(3)
  int quantity = 0;

  @HiveField(4)
  int type = 0;

  PurchaseHiveModel(this.name, this.total, this.value, this.quantity,
      this.type);
}