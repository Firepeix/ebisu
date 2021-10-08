import 'package:hive/hive.dart';

part 'ShoppingListModels.g.dart';

@HiveType(typeId : 2)
class ShoppingListHiveModel extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  int amount = 0;

  @HiveField(2)
  String serializedPurchases;

  ShoppingListHiveModel(this.name, this.amount, this.serializedPurchases);
}