import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/card/Infrastructure/CardModuleServiceProvider.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ExpenditureForm extends StatefulWidget {
  final ExpenditureFormValidator validator = ExpenditureFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final CardRepositoryInterface cardRepository = CardModuleServiceProvider.cardRepository();
  final ExpenditureRepositoryInterface expenditureRepository = ExpenditureModuleServiceProvider.expenditureRepository();
  @override
  State<StatefulWidget> createState() => _ExpenditureFormState();

  Widget build (_ExpenditureFormState state) {
    return Form(
      key: state._formKey,
      child: KeyboardAvoider(
        autoScroll: true,
        child: Column(
          children: <Widget>[
            TextFormField(
              validator: (value) => validator.name(value),
              decoration: decorator.textForm('Nome', 'Adicione o nome da despesa.'),
            ),
            Padding(
              padding: EdgeInsets.only(right: 16),
              child: RadioGroup(
                children: [
                  RadioInput(label: 'Credito', value: 'CREDIT', groupValue: state._type, onChanged: state.handleTypeChange),
                  RadioInput(label: 'Debito', value: 'DEBIT', groupValue: state._type, onChanged: state.handleTypeChange)
                ],
              ),
            ),
            SelectInput(
              value: state._card,
              onChanged: state.handleCardChange,
              decoration: decorator.selectForm('Cartão', 'Selecione o cartão'),
              items: cardRepository.getCardTypes(),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: SelectInput(
                value: state._expenditureType,
                onChanged: state.handleExpenditureTypeChange,
                decoration: decorator.selectForm('Tipo', 'Selecione o tipo da despesa'),
                items: expenditureRepository.getExpenditureTypes(),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(flex: 10,child: TextFormField(
                    validator: (value) => validator.name(value),
                    decoration: decorator.textForm('Parcela Atual', 'Adicione a parcela atual.'),
                  )),
                  Spacer(flex: 1,),
                  Expanded(flex: 10,child: TextFormField(
                    validator: (value) => validator.name(value),
                    decoration: decorator.textForm('Total de Parcelas', 'Adicione o total de parcelas'),
                  )),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: TextFormField(
                initialValue: '0,00',
                maxLength: 8,
                textAlign: TextAlign.center,
                maxLengthEnforcement: MaxLengthEnforcement.enforced,
                keyboardType: TextInputType.number,
                style: TextStyle(fontSize: 76, fontWeight: FontWeight.w500),
                validator: (value) => validator.name(value),
                decoration: decorator.amountForm(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExpenditureFormState extends State<ExpenditureForm> {
  final _formKey = GlobalKey<FormState>();
  String? _type;
  String? _card;
  String? _expenditureType;

  @override
  Widget build(BuildContext context) => widget.build(this);

  void handleTypeChange(String? value) {
    setState(() {
      _type = value;
    });
  }

  void handleExpenditureTypeChange(String? value) {
    setState(() {
      _expenditureType = value;
    });
  }

  void handleCardChange(String? value) {
    setState(() {
      _card = value;
    });
  }
}

class ExpenditureFormValidator {
  String? name (String? value) {
    if (value == null || value.isEmpty) {
      return 'Nome dá despesa é obrigatório';
    }
    return null;
  }
}
