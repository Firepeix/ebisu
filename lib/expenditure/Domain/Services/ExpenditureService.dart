import 'package:ebisu/card/Domain/Card.dart';

import '../Expenditure.dart';
import 'ExpenditureServiceInterface.dart';

class ExpenditureService implements ExpenditureServiceInterface {
  Expenditure createExpenditure(ExpenditureBuilder builder) {
    return Expenditure(
      name: ExpenditureName(builder.name),
      amount: ExpenditureAmount(builder.amount),
      type: CardClass.values[builder.type],
      cardType: builder.cardType != null ? CardType(builder.cardType!) : null,
      expenditureType: builder.expenditureType != null ? ExpenditureType.values[builder.expenditureType!] : null,
      installments: builder.currentInstallment != null ? ExpenditureInstallments(currentInstallment: builder.currentInstallment!, totalInstallments: builder.installmentTotal!) : null,
    );
  }
}