import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';

class AmountFormModel {
  String? name;
  int? amount;
  DateTime? date;
  ExpenseType? type;
  CardModel? card;
  Source? source;
  Source? beneficiary;
  int? currentInstallment;
  int? totalInstallments;

  bool isInstallmentBased() {
    return currentInstallment != null;
  }
}

