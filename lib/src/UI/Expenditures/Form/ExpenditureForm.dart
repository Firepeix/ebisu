import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';
import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';

class ExpenditureForm extends StatefulWidget {
  final ExpenditureFormValidator validator = ExpenditureFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();
  final Map<int, String> cardTypes;

  ExpenditureForm({required this.cardTypes, Key? formKey}) : super(key: formKey);


  @override
  State<StatefulWidget> createState() =>  ExpenditureFormState(formKey: _internalFormKey);

  Widget build (ExpenditureFormState state) {
    return Form(
      key: _internalFormKey,
      child: KeyboardAvoider(
        autoScroll: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              onSaved: (value) => state.model.name = value!,
              validator: (value) => validator.name(value),
              decoration: decorator.textForm('Nome', 'Adicione o nome da despesa.'),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16, top: 10),
              child: RadioGroup(
                onSaved: (value) => state.model.type = state._type!,
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
                      onSaved: (value) => state.model.cardType = cardTypes[value] ?? null,
                      onChanged: (value) => state._cardType = value,
                      validator: (value) => validator.card(value, state._type == CardClass.CREDIT.index),
                      decoration: decorator.selectForm('Cart??o', 'Selecione o cart??o'),
                      items: cardTypes,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SelectInput(
                      onSaved: (value) => state.model.expenditureType = value,
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
                      onSaved: (value) => state.model.currentInstallment = value,
                      validator: (value) => validator.activeInstallment(value, state._expenditureType == ExpenditureType.PARCELADA.index),
                      decoration: decorator.textForm('Parcela Atual', 'Adicione a parcela atual.'),
                    )),
                    Spacer(flex: 1,),
                    Expanded(flex: 10,child: NumberInput(
                      onSaved: (value) => state.model.installmentTotal = value,
                      validator: (value) => validator.totalInstallments(value, state._expenditureType == ExpenditureType.PARCELADA.index),
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
                onSaved: (value) => state.model.amount = value!,
                validator: (value) => validator.amount(value),
              ),
              ),
          ],
        ),
      ),
    );
  }
}

class ExpenditureFormState extends State<ExpenditureForm> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey;
  late AnimationController creditOptionsController;
  late AnimationController installmentOptionsController;
  final ExpenditureModel model = ExpenditureModel();

  int? _type;
  int? _expenditureType;
  int? _cardType;
  int? amount;

  ExpenditureFormState({required this.formKey}) {
    this.creditOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    this.installmentOptionsController = AnimationController(vsync: this, duration: Duration(milliseconds: 500));
  }

  ExpenditureModel submit () {
    if(this.formKey.currentState!.validate()) {
      this.formKey.currentState!.save();
      return model;
    }

    throw Exception('Formul??rio Invalido');
  }

  bool validate () {
    return this.formKey.currentState!.validate();
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

  void handleExpenditureTypeChange(int? value) {
    setState(() {
      _expenditureType = value;
      if(value != null && value == ExpenditureType.PARCELADA.index) {
        installmentOptionsController.forward();
        return;
      }
      installmentOptionsController.reverse();
    });
  }

  void handleAmountChange(int? value) {
    setState(() {
      amount = value;
    });
  }
}

class ExpenditureFormValidator extends InputValidator{
  String? name (String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome d?? despesa ?? obrigat??rio';
    }
    return null;
  }

  String? type (int? value) {
    if (this.isRequired(value)) {
      return 'Classe da despesa ?? obrigat??rio';
    }
    return null;
  }

  String? card (int? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Cart??o da Despesa ?? obrigat??rio';
    }
    return null;
  }

  String? expenditureType (int? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Tipo de despesa ?? obrigat??rio';
    }
    return null;
  }

  String? activeInstallment (String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Obrigat??rio';
    }
    return null;
  }

  String? totalInstallments (String? value, bool required) {
    if (required && this.isRequired(value)) {
      return 'Obrigat??rio';
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
    return 'Classe da despesa ?? obrigat??rio';
  }
}

class ExpenditureModel implements ExpenditureBuilder{
  String? _name;
  int? _type;
  int? _amount;
  String? _cardType;
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

  String? get cardType => _cardType;

  set cardType (String? cardType) {
    this._cardType = cardType;
  }

  int? get expenditureType => _expenditureType;

  set expenditureType(int? value) {
    _expenditureType = value != null ? value : null;
  }

}

class ExpenditureFormSkeleton extends StatelessWidget {
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
