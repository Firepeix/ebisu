import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/common/entry/components/amount_payment_type.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';

import 'amount_form.dart';

class AmountFormValidator extends InputValidator {
  final List<AmountFormFeature> _features;

  const AmountFormValidator(this._features);

  String? name(String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome dá despesa é obrigatório';
    }
    return null;
  }

  String? type(ExpenseType? value) {
    if (this.isRequired(value) && _features.contains(AmountFormFeature.EXPENSE_CLASS)) {
      return 'Classe da despesa é obrigatório';
    }
    return null;
  }

  String? card(CardModel? value, bool required) {
    if (required && isRequired(value) && _features.contains(AmountFormFeature.CARD_CHOOSER)) {
      return 'Cartão da Despesa é obrigatório';
    }
    return null;
  }

  String? expenditureType(AmountPaymentType? value) {
    if (isRequired(value) &&  _features.contains(AmountFormFeature.PAYMENT_TYPE)) {
      return 'Tipo de pagamento de despesa é obrigatório';
    }
    return null;
  }

  String? activeInstallment(String? value, bool required) {
    if (required && this.isRequired(value) && _features.contains(AmountFormFeature.PAYMENT_TYPE)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? date(DateTime? value) {
    if (isRequired(value) && _features.contains(AmountFormFeature.DATE)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? totalInstallments(String? value, bool required) {
    if (required && this.isRequired(value) && _features.contains(AmountFormFeature.PAYMENT_TYPE)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? source(ExpenseSourceModel? value, bool required, AmountFormFeature feature) {
    if (required && isRequired(value) && _features.contains(feature)) {
      return 'Fonte é obrigatória';
    }

    if (required && isRequired(value) && _features.contains(feature)) {
      return 'Beneficiario é obrigatório';
    }

    return null;
  }

  String? amount(String? value) {
    if (!this.isRequired(value)) {
      int? amount = Money.parse(value ?? "");
      if (amount != null) {
        return amount > 0 ? null : 'Valor deve ser maior que 0';
      }
    }
    return 'Classe da despesa é obrigatório';
  }
}