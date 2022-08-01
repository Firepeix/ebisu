import 'package:ebisu/shared/form/BiFormValue.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class TravelExpenseForm extends StatefulWidget {
  final ExpenditureFormValidator validator = ExpenditureFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();

  TravelExpenseForm({Key? formKey}) : super(key: formKey);


  @override
  State<StatefulWidget> createState() =>  ExpenditureFormState(formKey: _internalFormKey);

  Widget build (ExpenditureFormState state) {
    return Form(
      key: _internalFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (value) => state.name = value!,
            validator: (value) => validator.name(value),
            decoration: decorator.textForm('Descrição', 'Adicione a descrição da despesa.'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: AmountInput(
              value: state.amount,
              onChanged: state.handleAmountChange,
              onSaved: (value) => state.amount = value!,
              validator: (value) => validator.amount(value),
            ),
          ),
        ],
      ),
    );
  }
}

class ExpenditureFormState extends State<TravelExpenseForm> {
  final GlobalKey<FormState> formKey;
  late AnimationController installmentOptionsController;

  String? name;
  int? amount;

  ExpenditureFormState({required this.formKey});

  BiFormValue<String, Money> submit () {
    if(this.formKey.currentState!.validate()) {
      this.formKey.currentState!.save();
      return BiFormValue(name!, Money(amount!));
    }

    throw Exception('Formulário Invalido');
  }

  bool validate () {
    return this.formKey.currentState!.validate();
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

  void handleAmountChange(int? value) {
    setState(() {
      amount = value;
    });
  }
}

class ExpenditureFormValidator extends InputValidator{
  String? name (String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Descrição da despesa é obrigatório';
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


