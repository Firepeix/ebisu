import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/common/core/domain/amount_form_model.dart';
import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/common/entry/components/amount_form_validator.dart';
import 'package:ebisu/modules/common/entry/components/amount_payment_type.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/modules/expenditure/events/change_main_button_on_action_notification.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/shared/utils/scope.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:ebisu/ui_components/chronos/cards/doc_note.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/date_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/number_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/select_input.dart';
import 'package:ebisu/ui_components/chronos/form/radio/radio_input.dart';
import 'package:flutter/material.dart';

enum AmountFormFeature {
  EXPENSE_CLASS,
  CARD_CHOOSER,
  PAYMENT_TYPE,
  DATE,
  BENEFICIARY,
  SOURCE
}

class AmountForm extends StatefulWidget {
  final List<AmountFormFeature> features;
  final void Function(AmountFormModel) onSaved;

  const AmountForm({super.key, required this.features, required this.onSaved});

  bool isEnabled(AmountFormFeature feature) {
    return features.contains(feature);
  }

  @override
  State<AmountForm> createState() => _AmountFormState();
}

class _AmountFormState extends State<AmountForm> with TickerProviderStateMixin {
  final List<CardModel> cards = [];
  final List<ExpenseSourceModel> sources = [];
  final AmountFormModel model = AmountFormModel();
  AmountPaymentType? _paymentType;
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
  }

  void setMainButtonAction(BuildContext context) {
    final onMainButtonPressed = () async {
      if (_form?.currentState != null && _form!.currentState!.validate()) {
        _form?.currentState?.save();
        widget.onSaved.call(model);
      }
    };
    context.dispatchNotification(ChangeMainButtonActionNotification(onMainButtonPressed));
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

  void _handleExpenditureTypeChange(AmountPaymentType? value) {
    setState(() {
      _paymentType = value;
      model.currentInstallment = null;
      model.totalInstallments = null;
      _currentInstallmentState?.currentState?.reset();
      _totalInstallmentState?.currentState?.reset();
      _showInstallments(value);
    });
  }

  void _showInstallments(AmountPaymentType? value) {
    if (value != null && _paymentType != AmountPaymentType.UNIT) {
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

  Widget _amountType(AmountFormValidator validator) {
    if (!widget.isEnabled(AmountFormFeature.EXPENSE_CLASS)) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(right: 16, top: 10),
      child: RadioGroup(
        validator: () => validator.type(model.type),
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
    );
  }

  Widget _cardSelector(AmountFormValidator validator) {
    if (!widget.isEnabled(AmountFormFeature.CARD_CHOOSER)) {
      return Container();
    }
    return SizeTransition(
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
                  validator.card(value, model.type != null && !model.type!.isDebit()),
              items: [],
            ),
          ),
        ],
      ),
    );
  }

  Widget _paymentTypeSelector(AmountFormValidator validator) {
    if (!widget.isEnabled(AmountFormFeature.PAYMENT_TYPE)) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: SelectInput<AmountPaymentType>(
        label: "Pagamento",
        value: _paymentType,
        onSaved: (value) => _paymentType = value,
        validator: (value) => validator.expenditureType(value),
        onChanged: _handleExpenditureTypeChange,
        items: AmountPaymentType.values,
      ),
    );
  }

  Widget _dateInput(AmountFormValidator validator) {
    if (!widget.isEnabled(AmountFormFeature.DATE)) {
      return Container();
    }
    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: DateInput(
        label: "Data",
        initialValue: model.date,
        validator: validator.date,
        onChanged: (value) => model.date = value,
      ),
    );
  }

  Widget _installmentSelector(AmountFormValidator validator) {
    if (!widget.isEnabled(AmountFormFeature.PAYMENT_TYPE)) {
      return Container();
    }
    return SizeTransition(
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
                  validator: (value) => validator
                      .activeInstallment(value, _paymentType != AmountPaymentType.UNIT),
                )),
            Visibility(
              visible: _paymentType == AmountPaymentType.INSTALLMENT,
              child: Spacer(
                flex: 1,
              ),
            ),
            Visibility(
                visible: _paymentType == AmountPaymentType.INSTALLMENT,
                child: Expanded(
                    flex: 10,
                    child: NumberInput(
                      initialValue: model.totalInstallments,
                      inputKey: _totalInstallmentState,
                      label: "Total de Parcelas",
                      onSaved: (value) => model.totalInstallments = value,
                      validator: (value) => validator
                          .totalInstallments(value, _paymentType == AmountPaymentType.INSTALLMENT),
                    ))),
          ],
        ),
      ),
    );
  }

  Widget _sourceSelector(AmountFormValidator validator, String title) {
    if (title == "Fonte") {
      if (!widget.isEnabled(AmountFormFeature.SOURCE)) {
        return Container();
      }

      return Padding(
        padding: EdgeInsets.only(top: 16),
        child: SelectInput<ExpenseSourceModel>(
          value: model.source?.let((it) => ExpenseSourceModel(it.id, it.name, it.type == SourceType.USER ? ExpenseSourceType.USER : ExpenseSourceType.ESTABLISHMENT)),
          onChanged: (c) => model.source = c?.let((it) => Source(id: it.id, name: it.name, type: it.type == ExpenseSourceType.USER ? SourceType.USER : SourceType.ESTABLISHMENT )),
          label: title,
          items: sources,
        ),
      );
    }

    if (!widget.isEnabled(AmountFormFeature.BENEFICIARY)) {
      return Container();
    }

    return Padding(
      padding: EdgeInsets.only(top: 16),
      child: SelectInput<ExpenseSourceModel>(
        value: model.beneficiary?.let((it) => ExpenseSourceModel(it.id, it.name, it.type == SourceType.USER ? ExpenseSourceType.USER : ExpenseSourceType.ESTABLISHMENT)),
        onChanged: (c) => model.beneficiary = c?.let((it) => Source(id: it.id, name: it.name, type: it.type == ExpenseSourceType.USER ? SourceType.USER : SourceType.ESTABLISHMENT )),
        label: title,
        items: sources,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final validator = AmountFormValidator(widget.features);

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
                validator: validator.name,
                onSaved: (value) => model.name = value!,
              ),
            ),
            _amountType(validator),
            _cardSelector(validator),
            _paymentTypeSelector(validator),
            _dateInput(validator),
            _installmentSelector(validator),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: AmountInput(
                value: model.amount,
                onChanged: (value) => model.amount = value,
                validator: (value) => validator.amount(value),
              ),
            ),
            _sharedCardWarning(),
            _sourceSelector(validator, "Beneficiário"),
            _sourceSelector(validator, "Fonte"),
          ],
        ),
      ),
    );
  }
}

class AmountFormSkeleton extends StatelessWidget {
  final List<AmountFormFeature> features;

  const AmountFormSkeleton({super.key, required this.features});

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
              features.contains(AmountFormFeature.EXPENSE_CLASS) ? Padding(
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
              ) : Container(),
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
