class ExpenseEntity {
  final String id;
  final String name;
  final int amount;
  final String date;
  final String type;
  final String? sourceId;
  final String? sourceName;
  final String? sourceType;
  final String? beneficiaryId;
  final String? beneficiaryName;
  final String? beneficiaryType;
  final int? currentInstallment;
  final int? totalInstallments;

  ExpenseEntity({required this.id, required this.name, required this.amount, required this.date, required this.type, required this.sourceId, required this.sourceName, required this.sourceType, required this.beneficiaryId, required this.beneficiaryName, required this.beneficiaryType, required this.currentInstallment, required this.totalInstallments});
}



