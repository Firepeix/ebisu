import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';

class ExpenditureForm extends StatefulWidget {
  final ExpenditureFormValidator validator = ExpenditureFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final CardRepositoryInterface cardRepository;
  final _formKey = GlobalKey<FormState>();
  final ExpenditureModel model = ExpenditureModel();
  ExpenditureForm({required this.cardRepository}) : super(key: GlobalKey<_ExpenditureFormState>());

  get stateKey => this._formKey;

  @override
  State<StatefulWidget> createState() =>  _ExpenditureFormState();

  ExpenditureModel submit () {
    if(this.stateKey.currentState!.validate()) {
      this.stateKey.currentState!.save();
      return model;
    }

    throw Exception('Formulário Invalido');
  }

  Widget build (_ExpenditureFormState state) {
    return Form(
      key: _formKey,
      child: KeyboardAvoider(
        autoScroll: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              onSaved: (value) => model.name = value!,
              validator: (value) => validator.name(value),
              decoration: decorator.textForm('Nome', 'Adicione o nome da despesa.'),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, top: 10),
              child: RadioGroup(
                onSaved: (value) => model.type = state._type!,
                validator: (value) => validator.type(state._type),
                children: [
                  RadioInput(label: 'Credito', value: CardClass.CREDIT.index, groupValue: state._type, onChanged: state.handleTypeChange),
                  RadioInput(label: 'Debito', value: CardClass.DEBIT.index, groupValue: state._type, onChanged: state.handleTypeChange)
                ],
              ),
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: CurvedAnimation(
                parent: state.creditOptionsController,
                curve: Curves.fastOutSlowIn,
              ),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SelectInput(
                      onSaved: (value) => model.cardType = value,
                      validator: (value) => validator.card(value, state._type == CardClass.CREDIT.index),
                      onChanged: state.handleCardChange,
                      decoration: decorator.selectForm('Cartão', 'Selecione o cartão'),
                      items: cardRepository.getCardTypes(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SelectInput(
                      onSaved: (value) => model.expenditureType = value,
                      validator: (value) => validator.expenditureType(value, state._type == CardClass.CREDIT.index),
                      onChanged: state.handleExpenditureTypeChange,
                      decoration: decorator.selectForm('Tipo', 'Selecione o tipo da despesa'),
                      items: Map.fromIterable(ExpenditureType.values, key: (e) => e.index, value: (e) => e.toString().split('.').elementAt(1)),
                    ),
                  ),
                ],
              ),
            ),
            SizeTransition(
              axisAlignment: 1.0,
              sizeFactor: CurvedAnimation(
                parent: state.installmentOptionsController,
                curve: Curves.fastOutSlowIn,
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 16),
                child: Row(
                  children: [
                    Expanded(flex: 10,child: NumberInput(
                      onSaved: (value) => model.currentInstallment = value,
                      onChanged: state.handleCurrentInstallmentChange,
                      validator: (value) => validator.activeInstallment(value, state._expenditureType == ExpenditureType.ASSINATURA.index.toString()),
                      decoration: decorator.textForm('Parcela Atual', 'Adicione a parcela atual.'),
                    )),
                    Spacer(flex: 1,),
                    Expanded(flex: 10,child: NumberInput(
                      onSaved: (value) => model.installmentTotal = value,
                      onChanged: state.handleInstallmentTotalChange,
                      validator: (value) => validator.totalInstallments(value, state._expenditureType == ExpenditureType.ASSINATURA.index.toString()),
                      decoration: decorator.textForm('Total de Parcelas', 'Adicione o total de parcelas'),
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: AmountInput(
                value: state.amount,
                onChanged: state.handleAmountChange,
                onSaved: (value) => model.amount = value!,
                validator: (value) => validator.amount(value),
              ),
              ),
          ],
        ),
      ),
    );
  }
}

class _ExpenditureFormState extends State<ExpenditureForm> with TickerProviderStateMixin {
  late AnimationController creditOptionsController;
  late AnimationController installmentOptionsController;

  int? _type;
  String? _card;
  String? _expenditureType;
  int? amount;
  int? _currentInstallment;
  int? _installmentTotal;

  _ExpenditureFormState() {
    this.creditOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    this.installmentOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

  void handleTypeChange(int? value) {
    setState(() {
      _type = value;
      if(value != null && value == CardClass.CREDIT.index) {
        creditOptionsController.forward();
        return;
      }
      creditOptionsController.reverse();
    });
  }

  void handleExpenditureTypeChange(String? value) {
    setState(() {
      _expenditureType = value;
      if(value != null && int.parse(value) == ExpenditureType.PARCELADA.index) {
        installmentOptionsController.forward();
        return;
      }
      installmentOptionsController.reverse();
    });
  }

  void handleCardChange(String? value) {
    setState(() {
      _card = value;
    });
  }

  void handleCurrentInstallmentChange(int? value) {
    setState(() {
      _currentInstallment = value;
    });
  }

  void handleAmountChange(int? value) {
    setState(() {
      amount = value;
    });
  }

  void handleInstallmentTotalChange(int? value) {
    setState(() {
      _installmentTotal = value;
    });
  }
}

class ExpenditureFormValidator extends InputValidator{
  String? name (String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome dá despesa é obrigatório';
    }
    return null;
  }

  String? type (int? value) {
    if (this.isRequired(value)) {
      return 'Classe da despesa é obrigatório';
    }
    return null;
  }

  String? card (String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Cartão da Despesa é obrigatório';
    }
    return null;
  }

  String? expenditureType (String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Tipo de despesa é obrigatório';
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

class ExpenditureModel implements ExpenditureBuilder{
  String? _name;
  int? _type;
  int? _amount;
  int? _cardType;
  int? _expenditureType;
  int? currentInstallment;
  int? installmentTotal;

  @override
  int get amount => _amount ?? 0;

  @override
  String get name => _name ?? '';

  @override
  int get type => _type ?? 0;

  set amount(int value) {
    _amount = value;
  }

  set type(int value) {
    _type = value;
  }

  set name(String value) {
    _name = value;
  }

  int? get expenditureType => _expenditureType;

  set expenditureType(dynamic value) {
    _expenditureType = value != null ? int.tryParse(value!) : null;
  }

  int? get cardType => _cardType;

  set cardType(dynamic value) {
    _cardType = value != null ? int.tryParse(value!) : null;
  }
}
