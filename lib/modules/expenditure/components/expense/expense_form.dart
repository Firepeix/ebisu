import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:ebisu/ui_components/chronos/form/radio/radio_input.dart';
import 'package:ebisu/ui_components/chronos/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/inputs/number_input.dart';
import 'package:ebisu/ui_components/chronos/inputs/select_input.dart';
import 'package:flutter/material.dart';

enum _ExpensePaymentType implements CanBePutInSelectBox{
  UNIT("Única"),
  FOREVER("Assinatura"),
  INSTALLMENT("Parcelada");

  final String label;

  const _ExpensePaymentType(this.label);

  String selectBoxLabel() {
    return label;
  }

  Color? selectBoxColor() {
    return null;
  }
}

class ExpenseForm extends StatefulWidget {
  final validator = const _ExpenditureFormValidator();
  final List<CardModel> cards;
  final List<ExpenseSourceModel> beneficiaries;
  const ExpenseForm (this.cards, this.beneficiaries, {Key? key}) : super(key: key);

  @override
  State<ExpenseForm> createState() => ExpenseFormState();
}

class ExpenseFormState extends State<ExpenseForm> with TickerProviderStateMixin{
  _ExpenseViewModel model = _ExpenseViewModel();
  _ExpensePaymentType? _paymentType;
  late AnimationController cardOptionsController;
  late AnimationController installmentOptionsController;
  GlobalKey<FormFieldState<dynamic>>? _cardState;
  GlobalKey<FormFieldState<dynamic>>? _currentInstallmentState;
  GlobalKey<FormFieldState<dynamic>>? _totalInstallmentState;

  @override
  void initState() {
    cardOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    installmentOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _cardState = GlobalKey<FormFieldState<dynamic>>();
    _currentInstallmentState = GlobalKey<FormFieldState<dynamic>>();
    _totalInstallmentState = GlobalKey<FormFieldState<dynamic>>();
    super.initState();
  }

  void _handleTypeChange(ExpenseType? value) {
    setState(() {
      model.type = value;
      model.card = null;
      _cardState?.currentState?.reset();
      if(value != null && !value.isDebit()) {
        cardOptionsController.forward();
        return;
      }
      cardOptionsController.reverse();
    });
  }

  void _handleExpenditureTypeChange(_ExpensePaymentType? value) {
    setState(() {
      _paymentType = value;
      model.currentInstallment = null;
      model.installmentTotal = null;
      _currentInstallmentState?.currentState?.reset();
      _totalInstallmentState?.currentState?.reset();
      if(value != null && _paymentType != _ExpensePaymentType.UNIT) {
        installmentOptionsController.forward();
        return;
      }
      installmentOptionsController.reverse();
    });
  }


  @override
  void dispose() {
    cardOptionsController.dispose();
    installmentOptionsController.dispose();
    _cardState = null;
    _currentInstallmentState = null;
    _totalInstallmentState = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      autoScroll: true,
      child: Column(
        children: <Widget>[
          Input(
            label: "Nome",
            validator: widget.validator.name,
            onSaved: (value) => model.name = value!,
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, top: 10),
            child: RadioGroup(
              validator: () => widget.validator.type(model.type),
              children: [
                RadioInput<ExpenseType>(label: ExpenseType.CREDIT.label, value: ExpenseType.CREDIT, groupValue: model.type, onChanged: _handleTypeChange,),
                RadioInput<ExpenseType>(label: ExpenseType.DEBIT.label, value: ExpenseType.DEBIT, groupValue: model.type, onChanged: _handleTypeChange,)
              ],
            ),
          ),
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: CurvedAnimation(
              parent: cardOptionsController,
              curve: Curves.fastOutSlowIn,
            ),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: 16),
                  child: SelectInput<CardModel>(
                    key: _cardState,
                    onChanged: (c) => model.card = c,
                    label: "Cartão",
                    validator: (value) => widget.validator.card(value, model.type != null && !model.type!.isDebit()),
                    items: widget.cards,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: SelectInput<_ExpensePaymentType>(
              label: "Pagamento",
              onSaved: (value) => _paymentType = value,
              validator: (value) => widget.validator.expenditureType(value),
              onChanged: _handleExpenditureTypeChange,
              items: _ExpensePaymentType.values,
            ),
          ),
          SizeTransition(
            axisAlignment: 1.0,
            sizeFactor: CurvedAnimation(
              parent: installmentOptionsController,
              curve: Curves.fastOutSlowIn,
            ),
            child: Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(
                      flex: 10,
                      child: NumberInput(
                        key: _currentInstallmentState,
                        label: "Parcela Atual",
                        onSaved: (value) => model.currentInstallment = value,
                        validator: (value) => widget.validator.activeInstallment(value, _paymentType != _ExpensePaymentType.UNIT),
                      )),
                  Visibility(visible: _paymentType == _ExpensePaymentType.INSTALLMENT, child: Spacer(flex: 1,),),
                  Visibility(
                      visible: _paymentType == _ExpensePaymentType.INSTALLMENT,
                      child: Expanded(flex: 10,
                          child: NumberInput(
                            key: _totalInstallmentState,
                            label: "Total de Parcelas",
                            onSaved: (value) => model.installmentTotal = value,
                            validator: (value) => widget.validator.totalInstallments(value, _paymentType == _ExpensePaymentType.INSTALLMENT),
                          )
                      )
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: AmountInput(
              value: model.amount,
              onChanged: (value) => model.amount = value,
              validator: (value) => widget.validator.amount(value),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: SelectInput<ExpenseSourceModel>(
              onChanged: (c) => model.beneficiary = c,
              label: "Beneficiário",
              items: widget.beneficiaries,
            ),
          ),
        ],
      ),
    );
  }
}

class _ExpenseViewModel{
  String? name;
  ExpenseType? type;
  int? amount = 0;
  CardModel? card;
  int? currentInstallment;
  int? installmentTotal;
  ExpenseSourceModel? source;
  ExpenseSourceModel? beneficiary;
}

class _ExpenditureFormValidator extends InputValidator {
  const _ExpenditureFormValidator();
  String? name (String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome dá despesa é obrigatório';
    }
    return null;
  }

  String? type (ExpenseType? value) {
    if (this.isRequired(value)) {
      return 'Classe da despesa é obrigatório';
    }
    return null;
  }

  String? card (CardModel? value, bool required) {
    if (required && isRequired(value)) {
      return 'Cartão da Despesa é obrigatório';
    }
    return null;
  }

  String? expenditureType (_ExpensePaymentType? value) {
    if (isRequired(value)) {
      return 'Tipo de pagamento de despesa é obrigatório';
    }
    return null;
  }

  String? activeInstallment (String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? totalInstallments (String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? amount (String? value) {
    if (!this.isRequired(value)) {
      double? amount = double.tryParse(value!.replaceAll(',', '.'));
      if (amount != null) {
        return amount > 0 ? null : 'Valor deve ser maior que 0';
      }
    }
    return 'Classe da despesa é obrigatório';
  }
}

class ExpenseFormSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(isLoading: true, child: Column(
        children: [
          Container(
            width: 351,
            height: 51,
            decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.all(Radius.circular(8)),
              shape: BoxShape.rectangle,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, top: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Row(children: [
                  Container(
                    width: 48,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text('Credito', style: TextStyle(color: Colors.grey, fontSize: 16),)
                ],),
                Row(children: [
                  Container(
                    width: 48,
                    height: 20,
                    decoration: const BoxDecoration(
                      color: Colors.grey,
                      shape: BoxShape.circle,
                    ),
                  ),
                  Text('Debito', style: TextStyle(color: Colors.grey, fontSize: 16),)
                ],)
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: AmountInput(
              enabled: false,
              value: 0,
            ),
          )
        ],
      )),
    );
  }
}
