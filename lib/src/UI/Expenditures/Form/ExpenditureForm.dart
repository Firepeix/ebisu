import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';

class ExpenditureForm extends StatefulWidget {
  final ExpenditureFormValidator validator = ExpenditureFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final CardRepositoryInterface cardRepository;
  final ExpenditureRepositoryInterface expenditureRepository;
  final _formKey = GlobalKey<FormState>();
  final state = _ExpenditureFormState();

  ExpenditureForm({required this.cardRepository, required this.expenditureRepository});

  get stateKey => this._formKey;

  @override
  State<StatefulWidget> createState() => state;

  ExpenditureResponse submit () {
    if(this.stateKey.currentState!.validate()) {
      return state.response();
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
              onChanged: state.handleNameChange,
              validator: (value) => validator.name(value),
              decoration: decorator.textForm('Nome', 'Adicione o nome da despesa.'),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, top: 10),
              child: RadioGroup(
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
                      value: state._card,
                      validator: (value) => validator.card(value, state._type == CardClass.CREDIT.index),
                      onChanged: state.handleCardChange,
                      decoration: decorator.selectForm('Cartão', 'Selecione o cartão'),
                      items: cardRepository.getCardTypes(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SelectInput(
                      value: state._expenditureType,
                      validator: (value) => validator.expenditureType(value, state._type == CardClass.CREDIT.index),
                      onChanged: state.handleExpenditureTypeChange,
                      decoration: decorator.selectForm('Tipo', 'Selecione o tipo da despesa'),
                      items: expenditureRepository.getExpenditureTypes(),
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
                      onChanged: state.handleCurrentInstallmentChange,
                      validator: (value) => validator.activeInstallment(value, state._expenditureType == ExpenditureType.ASSINATURA.index.toString()),
                      decoration: decorator.textForm('Parcela Atual', 'Adicione a parcela atual.'),
                    )),
                    Spacer(flex: 1,),
                    Expanded(flex: 10,child: NumberInput(
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
                value: state._amount,
                onChanged: state.handleAmountChange,
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
  String? _name;
  String? _expenditureType;
  int? _amount;
  int? _currentInstallment;
  int? _installmentTotal;

  _ExpenditureFormState() {
    this.creditOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    this.installmentOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

  ExpenditureResponse response () {
    return ExpenditureResponse(
        name: _name!,
        type: _type!,
        amount: _amount!,
        cardType: _card != null ? int.tryParse(_card!) : null,
        expenditureType: _expenditureType != null ? int.tryParse(_expenditureType!) : null,
        currentInstallment: _currentInstallment,
        installmentTotal: _installmentTotal,
    );
  }

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

  void handleNameChange(String? value) {
    setState(() {
      this._name = value;
    });
  }

  void handleCurrentInstallmentChange(int? value) {
    setState(() {
      _currentInstallment = value;
    });
  }

  void handleAmountChange(int? value) {
    setState(() {
      _amount = value;
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

class ExpenditureResponse {
  final String name;
  final int type;
  final int amount;
  final int? cardType;
  final int? expenditureType;
  final int? currentInstallment;
  final int? installmentTotal;

  ExpenditureResponse({
    required this.name,
    required this.type,
    required this.amount,
    this.cardType,
    this.expenditureType,
    this.currentInstallment,
    this.installmentTotal
  });
}
