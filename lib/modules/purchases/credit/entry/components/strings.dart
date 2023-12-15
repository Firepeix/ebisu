import 'package:ebisu/modules/expenditure/components/purchases/credit_summaries.dart';
import 'package:ebisu/modules/user/entry/component/user_context.dart';

extension CreditSummaryStrings on CreditSummaries {
    static final installment = {
      Skin.TUTU: "Parcelado",
      Skin.WEWE: "Gastos Parcelados"
    };

    static final spent = {
      Skin.TUTU: "Gasto atual",
      Skin.WEWE: "Gastos a Vista"
    };
}