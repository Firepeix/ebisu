import 'package:ebisu/shared/UI/Components/Shimmer.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:ebisu/src/UI/Components/Form/InputFactory.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:flutter/material.dart';

class ShoppingListForm extends StatefulWidget {
  final ShoppingListFormValidator validator = ShoppingListFormValidator();
  final InputFormDecorator decorator = InputFormDecorator();
  final GlobalKey<FormState> _internalFormKey = GlobalKey<FormState>();
  final SHOPPING_LIST_TYPE formType;

  ShoppingListForm({this.formType: SHOPPING_LIST_TYPE.BLANK, Key? formKey}) : super(key: formKey);

  @override
  State<StatefulWidget> createState() =>  ShoppingListFormState(formKey: _internalFormKey);

  Widget build (ShoppingListFormState state) {
    state.model.type = formType.index.toInt();
    return Form(
      key: _internalFormKey,
      child: Column(
        children: <Widget>[
          TextFormField(
            onSaved: (value) => state.model.name = value!,
            validator: (value) => validator.name(value),
            decoration: decorator.textForm('Nome', formType == SHOPPING_LIST_TYPE.BLANK ? 'Adicione o nome da lista de compras.' : 'Adicione o nome da planilha da lista de compras'),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: Visibility(
              visible: formType == SHOPPING_LIST_TYPE.BLANK,
              child: AmountInput(
                value: state.amount,
                onChanged: state.handleAmountChange,
                onSaved: (value) {
                  if (formType == SHOPPING_LIST_TYPE.BLANK) {
                    state.model.amount = value!;
                    return;
                  }
                  state.model.amount = 3;
                },
                validator: (value) => validator.amount(value),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ShoppingListFormState extends State<ShoppingListForm> with TickerProviderStateMixin {
  final GlobalKey<FormState> formKey;
  final ShoppingListModel model = ShoppingListModel();

  int? amount;

  ShoppingListFormState({required this.formKey});

  ShoppingListModel submit () {
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
}

class ShoppingListFormValidator extends InputValidator{
  String? name (String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome da lista de compras é obrigatório';
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
    return 'Valor da despesa é obrigatório';
  }
}

class ShoppingListModel implements ShoppingListBuilder {
  String? _name;
  int? _type;
  int? _amount;

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
}

class ShoppingListSkeleton extends StatelessWidget {
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
