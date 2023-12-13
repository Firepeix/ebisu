
import '../../../../common/core/domain/money.dart';

class DebitSummary {
  final Money currentNetAmount;
  final Money amountToPay;
  final Money payedAmount;
  final Money totalAmount;
  final Money forecastAmount;
  final Money currentAmount;

  DebitSummary({required this.currentNetAmount, required this.amountToPay, required this.payedAmount, required this.totalAmount, required this.forecastAmount, required this.currentAmount});
}