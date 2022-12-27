import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';
import 'package:ebisu/modules/expenditure/events/change_main_button_on_action_notification.dart';
import 'package:ebisu/modules/expenditure/events/save_expense_notification.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:ebisu/ui_components/chronos/cards/doc_note.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/date_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/number_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
import 'package:ebisu/ui_components/chronos/form/radio/radio_input.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

enum _ExpensePaymentType implements CanBePutInSelectBox {
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
  final CreatesExpense? model;

  const ExpenseForm(this.cards, this.beneficiaries, {Key? key, this.model}) : super(key: key);

  @override
  State<ExpenseForm> createState() => _ExpenseFormState();
}

class _ExpenseFormState extends State<ExpenseForm> with TickerProviderStateMixin {
  _ExpenseViewModel model = _ExpenseViewModel(date: DateTime.now());
  _ExpensePaymentType? _paymentType;
  late AnimationController cardOptionsController;
  late AnimationController installmentOptionsController;
  late AnimationController sharedController;
  GlobalKey<FormFieldState<dynamic>>? _cardState;
  GlobalKey<FormFieldState<dynamic>>? _currentInstallmentState;
  GlobalKey<FormFieldState<dynamic>>? _totalInstallmentState;
  GlobalKey<FormState>? _form;
  bool isSharedExpense = false;

  @override
  void initState() {
    super.initState();
    setMainButtonAction(context);
    cardOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    installmentOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    sharedController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _cardState = GlobalKey<FormFieldState<dynamic>>();
    _currentInstallmentState = GlobalKey<FormFieldState<dynamic>>();
    _totalInstallmentState = GlobalKey<FormFieldState<dynamic>>();
    _form = GlobalKey<FormState>();
    setModel();
  }

  void setMainButtonAction(BuildContext context) {
    final onMainButtonPressed = () async {
      if (_form?.currentState != null && _form!.currentState!.validate()) {
        _form?.currentState?.save();
        context.dispatchNotification(SaveExpenseNotification(model));
      }
    };
    context.dispatchNotification(ChangeMainButtonActionNotification(onMainButtonPressed));
  }

  void setModel() {
    if (widget.model != null) {
      model = _ExpenseViewModel(
          name: widget.model!.getName(),
          type: widget.model!.getType(),
          amount: widget.model!.getAmount(),
          card: widget.model!.getCard(),
          date: widget.model!.getDate(),
          currentInstallment: widget.model!.getCurrentInstallment(),
          installmentTotal: widget.model!.getTotalInstallments(),
          beneficiary: widget.model!.getBeneficiary());

      _showCards(model.type);
      if (model.installmentTotal != null) {
        _paymentType = _ExpensePaymentType.INSTALLMENT;
      } else {
        _paymentType =
            model.currentInstallment != null ? _ExpensePaymentType.FOREVER : _ExpensePaymentType.UNIT;
      }

      _showInstallments(_paymentType);
    }
  }

  @override
  void dispose() {
    cardOptionsController.dispose();
    installmentOptionsController.dispose();
    sharedController.dispose();
    _cardState = null;
    _currentInstallmentState = null;
    _totalInstallmentState = null;
    _form = null;
    super.dispose();
  }

  void _handleTypeChange(ExpenseType? value) {
    setState(() {
      model.type = value;
      model.card = null;
      _cardState?.currentState?.reset();
      _showCards(value);
    });
  }

  void _showCards(ExpenseType? value) {
    if (value != null && !value.isDebit()) {
      cardOptionsController.forward();
      return;
    }
    cardOptionsController.reverse();
  }

  void _handleExpenditureTypeChange(_ExpensePaymentType? value) {
    setState(() {
      _paymentType = value;
      model.currentInstallment = null;
      model.installmentTotal = null;
      _currentInstallmentState?.currentState?.reset();
      _totalInstallmentState?.currentState?.reset();
      _showInstallments(value);
    });
  }

  void _showInstallments(_ExpensePaymentType? value) {
    if (value != null && _paymentType != _ExpensePaymentType.UNIT) {
      installmentOptionsController.forward();
      return;
    }
    installmentOptionsController.reverse();
  }

  void _onCardChanged(CardModel? card) {
    model.card = card;
    if (card?.isShared ?? false) {
      setState(() {
        isSharedExpense = true;
      });
      sharedController.forward();
      return;
    }

    isSharedExpense = false;
    sharedController.reverse();
  }

  Widget _sharedCardWarning() {
    return SizeTransition(
      axisAlignment: 1.0,
      sizeFactor: CurvedAnimation(
        parent: sharedController,
        curve: Curves.fastOutSlowIn,
      ),
      child: Padding(
        padding: EdgeInsets.only(top: 6),
        child: DocNote(
           "Atenção",
          "Este cartão é compartilhado, o valor inserido irá ser dividido entre ${model.card?.sharedAmount ?? 0} pessoas",
            DocNoteType.Warning),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return KeyboardAvoider(
      autoScroll: true,
      child: Form(
        key: _form,
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(top: 8),
              child: Input(
                label: "Nome",
                initialValue: model.name,
                validator: widget.validator.name,
                onSaved: (value) => model.name = value!,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, top: 10),
              child: RadioGroup(
                validator: () => widget.validator.type(model.type),
                children: [
                  RadioInput<ExpenseType>(
                    label: ExpenseType.CREDIT.label,
                    value: ExpenseType.CREDIT,
                    groupValue: model.type,
                    onChanged: _handleTypeChange,
                  ),
                  RadioInput<ExpenseType>(
                    label: ExpenseType.DEBIT.label,
                    value: ExpenseType.DEBIT,
                    groupValue: model.type,
                    onChanged: _handleTypeChange,
                  )
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
                      value: model.card,
                      inputKey: _cardState,
                      onChanged: _onCardChanged,
                      label: "Cartão",
                      validator: (value) =>
                          widget.validator.card(value, model.type != null && !model.type!.isDebit()),
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
                value: _paymentType,
                onSaved: (value) => _paymentType = value,
                validator: (value) => widget.validator.expenditureType(value),
                onChanged: _handleExpenditureTypeChange,
                items: _ExpensePaymentType.values,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: DateInput(
                label: "Data",
                initialValue: model.date,
                validator: widget.validator.date,
                onChanged: (value) => model.date = value,
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
                          initialValue: model.currentInstallment,
                          inputKey: _currentInstallmentState,
                          label: "Parcela Atual",
                          onSaved: (value) => model.currentInstallment = value,
                          validator: (value) => widget.validator
                              .activeInstallment(value, _paymentType != _ExpensePaymentType.UNIT),
                        )),
                    Visibility(
                      visible: _paymentType == _ExpensePaymentType.INSTALLMENT,
                      child: Spacer(
                        flex: 1,
                      ),
                    ),
                    Visibility(
                        visible: _paymentType == _ExpensePaymentType.INSTALLMENT,
                        child: Expanded(
                            flex: 10,
                            child: NumberInput(
                              initialValue: model.installmentTotal,
                              inputKey: _totalInstallmentState,
                              label: "Total de Parcelas",
                              onSaved: (value) => model.installmentTotal = value,
                              validator: (value) => widget.validator
                                  .totalInstallments(value, _paymentType == _ExpensePaymentType.INSTALLMENT),
                            ))),
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
            _sharedCardWarning(),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: SelectInput<ExpenseSourceModel>(
                value: model.beneficiary,
                onChanged: (c) => model.beneficiary = c,
                label: "Beneficiário",
                items: widget.beneficiaries,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenseViewModel implements CreatesExpense {
  String? name;

  @override
  String getName() => name!;

  ExpenseType? type;

  @override
  ExpenseType getType() => type!;

  int? amount = 0;

  @override
  int getAmount() => amount!;

  CardModel? card;

  @override
  CardModel? getCard() => card;

  DateTime? date = DateTime.now();

  @override
  DateTime getDate() => date!;

  int? currentInstallment;

  @override
  int? getCurrentInstallment() => currentInstallment;

  int? installmentTotal;

  @override
  int? getTotalInstallments() => installmentTotal;

  ExpenseSourceModel? beneficiary;

  @override
  ExpenseSourceModel? getBeneficiary() => beneficiary;

  @override
  ExpenseSourceModel? getSource() => null;

  _ExpenseViewModel(
      {this.name,
      this.type,
      this.amount,
      this.card,
      this.date,
      this.currentInstallment,
      this.installmentTotal,
      this.beneficiary});
}

class _ExpenditureFormValidator extends InputValidator {
  const _ExpenditureFormValidator();
  String? name(String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome dá despesa é obrigatório';
    }
    return null;
  }

  String? type(ExpenseType? value) {
    if (this.isRequired(value)) {
      return 'Classe da despesa é obrigatório';
    }
    return null;
  }

  String? card(CardModel? value, bool required) {
    if (required && isRequired(value)) {
      return 'Cartão da Despesa é obrigatório';
    }
    return null;
  }

  String? expenditureType(_ExpensePaymentType? value) {
    if (isRequired(value)) {
      return 'Tipo de pagamento de despesa é obrigatório';
    }
    return null;
  }

  String? activeInstallment(String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? date(DateTime? value) {
    if (isRequired(value)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? totalInstallments(String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Obrigatório';
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

class ExpenseFormSkeleton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Shimmer(
      child: ShimmerLoading(
          isLoading: true,
          child: Column(
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
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          'Credito',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: 48,
                          height: 20,
                          decoration: const BoxDecoration(
                            color: Colors.grey,
                            shape: BoxShape.circle,
                          ),
                        ),
                        Text(
                          'Debito',
                          style: TextStyle(color: Colors.grey, fontSize: 16),
                        )
                      ],
                    )
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
