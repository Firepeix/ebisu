import 'package:hive/hive.dart';

@HiveType(typeId : 1)
class ExpenditureHiveModel extends HiveObject {
  @HiveField(0)
  String name = '';

  @HiveField(1)
  int type = 0;

  @HiveField(2)
  int amount = 0;

  @HiveField(3)
  String? cardType = '';

  @HiveField(4)
  int? expenditureType = 0;

  @HiveField(5)
  int? currentInstallment = 0;

  @HiveField(6)
  int? totalInstallment = 0;

  ExpenditureHiveModel({required this.name, required this.type, required this.amount, this.cardType,
      this.expenditureType, this.currentInstallment, this.totalInstallment});
}