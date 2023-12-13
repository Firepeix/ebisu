class DebitSummaryEntity {
  final int currentNetAmount;
  final int amountToPay;
  final int payedAmount;
  final int totalAmount;
  final int forecastAmount;
  final int currentAmount;

  DebitSummaryEntity({required this.currentNetAmount, required this.amountToPay, required this.payedAmount, required this.totalAmount, required this.forecastAmount, required this.currentAmount});
}