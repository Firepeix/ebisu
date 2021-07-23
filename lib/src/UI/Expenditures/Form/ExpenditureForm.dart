import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/CardModuleServiceProvider.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';

class ExpenditureForm extends StatefulWidget {
  final ExpenditureFormValidator validator = ExpenditureFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final CardRepositoryInterface cardRepository = CardModuleServiceProvider.cardRepository();
  final ExpenditureRepositoryInterface expenditureRepository = ExpenditureModuleServiceProvider.expenditureRepository();
  final _formKey = GlobalKey<FormState>();

  get stateKey => this._formKey;


  @override
  State<StatefulWidget> createState() => _ExpenditureFormState();

  Widget build (_ExpenditureFormState state) {
    return Form(
      key: _formKey,
      child: KeyboardAvoider(
        autoScroll: true,
        child: Column(
          children: <Widget>[
            TextFormField(
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
                      validator: (value) => validator.card(value),
                      onChanged: state.handleCardChange,
                      decoration: decorator.selectForm('Cartão', 'Selecione o cartão'),
                      items: cardRepository.getCardTypes(),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: SelectInput(
                      value: state._expenditureType,
                      validator: (value) => validator.expenditureType(value),
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
                      validator: (value) => validator.activeInstallment(value),
                      decoration: decorator.textForm('Parcela Atual', 'Adicione a parcela atual.'),
                    )),
                    Spacer(flex: 1,),
                    Expanded(flex: 10,child: NumberInput(
                      validator: (value) => validator.totalInstallments(value),
                      decoration: decorator.textForm('Total de Parcelas', 'Adicione o total de parcelas'),
                    )),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: AmountInput(
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

  String? card (String? value) {
    if (this.isRequired(value)) {
      return 'Cartão da Despesa é obrigatório';
    }
    return null;
  }

  String? expenditureType (String? value) {
    if (this.isRequired(value)) {
      return 'Tipo de despesa é obrigatório';
    }
    return null;
  }

  String? activeInstallment (String? value) {
    if (this.isRequired(value)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? totalInstallments (String? value) {
    if (this.isRequired(value)) {
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
