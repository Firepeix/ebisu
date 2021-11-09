
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:flutter/material.dart';

class PurchaseForm extends StatefulWidget {
  final PurchaseFormValidator validator = PurchaseFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final String defaultName;
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();

  PurchaseForm({Key? formKey, this.defaultName: 'Compra'}) : super(key: formKey);

  @override
  State<StatefulWidget> createState() =>  PurchaseFormState(formKey: _internalFormKey);

  Widget build (PurchaseFormState state) {
    return Form(
      key: _internalFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (value) => state.model.name = value!,
            decoration: decorator.textForm('Nome', 'Adicione o nome da compra.'),
            initialValue: defaultName,
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: TextFormField(
              onSaved: (value) => state.model.quantity = double.tryParse(value!)!.floor(),
              keyboardType: TextInputType.number,
              validator: (value) => validator.quantity(value),
              decoration: decorator.textForm('Quantia', 'Adicione a quantia'),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(right: 16, top: 10),
            child: RadioGroup(
              onSaved: (value) => state.model.type = AmountType.values[state.type!],
              validator: (value) => validator.type(state.type),
              children: [
                RadioInput(label: 'Unitário', value: AmountType.UNIT.index, groupValue: state.type, onChanged: state.handleTypeChange),
                RadioInput(label: 'Peso (g)', value: AmountType.WEIGHT.index, groupValue: state.type, onChanged: state.handleTypeChange)
              ],
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
    );
  }
}

class PurchaseFormState extends State<PurchaseForm> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey;
  final PurchaseModel model = PurchaseModel();

  int? type;
  int? amount;

  PurchaseFormState({required this.formKey});

  PurchaseModel submit () {
    if(this.formKey.currentState!.validate()) {
      this.formKey.currentState!.save();
      return model;
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

  void handleTypeChange(int? value) {
    setState(() {
      type = value;
    });
  }
}

class PurchaseFormValidator extends InputValidator {
  String? quantity (String? value) {
    if (!this.isRequired(value)) {
      int? quantity = int.tryParse(value!.replaceAll(',', '.'));
      if (quantity != null) {
        return quantity > 0 ? null : 'Quantidade deve ser maior que 0';
      }
    }
    return 'Quantidade da compra é obrigatório';
  }

  String? type (int? value) {
    if (this.isRequired(value)) {
      return 'Tipo da compra é obrigatório';
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
    return 'Valor da compra é obrigatório';
  }
}

class PurchaseModel implements PurchaseBuilder {
  String? _name;
  int? _quantity;
  AmountType? _type;
  int? _amount;

  int get quantity => _quantity ?? 0;

  set quantity(int value) {
    _quantity = value;
  }

  @override
  int get amount => _amount ?? 0;

  set amount(int value) {
    _amount = value;
  }

  @override
  String get name => _name ?? '';

  set name(String value) {
    _name = value;
  }

  @override
  AmountType get type => _type ?? AmountType.UNIT;

  set type(AmountType value) {
    _type = value;
  }
}