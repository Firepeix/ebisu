import 'dart:async';

import 'package:ebisu/modules/card/components/card_form_skeleton.dart';
import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/events/save_card_notification.dart';
import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:ebisu/ui_components/chronos/actions/tap.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/number_input.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:flutter/material.dart';

class CardForm extends StatefulWidget {
  final validator = const _CardFormValidator();
  final CardServiceInterface? service;
  final String? cardId;
  final OnTap<VoidCallback>? submit;
  CardForm ({Key? key, this.cardId, this.service, this.submit}) : super(key: key);

  @override
  State<CardForm> createState() => _CardFormState();
}

class _CardViewModel implements SaveCardModel {
  String? name;

  @override
  String getName() => name!;

  int? budget = 0;

  @override
  int getBudget() => budget!;

  DateTime? dueDate;
  DateTime? getDueDate() => dueDate;

  DateTime? closeDate;
  @override
  DateTime? getCloseDate() => closeDate;


  _CardViewModel({
    this.name,
    this.budget,
    this.dueDate,
    this.closeDate,
  });
}

class _CardFormValidator extends InputValidator {
  const _CardFormValidator();

  String? name (String? value) {
    if (this.isRequired(value) || value!.length < 3) {
      return 'Nome do cartão é obrigatório';
    }
    return null;
  }


  String? date (String? value) {
    if (isRequired(value)) {
      return 'Obrigatório';
    }
    return null;
  }

  String? amount (String? value) {
    if (!this.isRequired(value)) {
      int? amount = Money.parse(value ?? "");
      if (amount != null) {
        return amount > 0 ? null : 'Valor deve ser maior que 0';
      }
    }
    return 'Orçamento é obrigatório';
  }
}


class _CardFormState extends State<CardForm> with TickerProviderStateMixin {
  _CardViewModel model = _CardViewModel();
  bool isLoading = false;
  GlobalKey<FormState>? _form;

  @override
  void initState() {
    super.initState();
    _form = GlobalKey<FormState>();
    setSubmitButtonAction();
    setModel();
  }

  void setSubmitButtonAction() {
    widget.submit?.action = () async {
      if (_form?.currentState != null && _form!.currentState!.validate()) {
        _form?.currentState?.save();
        context.dispatchNotification(SaveCardNotification(model));
      }
    };
  }

  Future<void> setModel() async {
    if (widget.cardId != null && widget.service != null) {
      isLoading = true;
      final result = await widget.service!.getCard(widget.cardId!);
      if(result.isOk()) {
        final card = result.unwrap();
        setState((){
          isLoading = false;
          model = _CardViewModel(
              name: card.getName(),
              budget: card.getBudget(),
              dueDate: card.getDueDate(),
              closeDate: card.getCloseDate()
          );
        });
      }
    }
  }

  @override
  void dispose() {
    _form = null;
    super.dispose();
  }

  KeyboardAvoider _formWidget() {
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
              padding: EdgeInsets.only(top: 16),
              child: Row(
                children: [
                  Expanded(flex: 10, child: NumberInput(
                    label: "Dia de Fechamento",
                    initialValue: model.closeDate?.day ?? 0,
                    validator: widget.validator.date,
                    onChanged: (value) {
                      final now = DateTime.now();
                      model.closeDate = DateTime(now.year, now.month, value?.toInt() ?? 0);
                    },
                  ),),
                  Spacer(),
                  Expanded(flex: 10, child: NumberInput(
                    label: "Dia de Vencimento",
                    initialValue: model.dueDate?.day ?? 0,
                    validator: widget.validator.date,
                    onChanged: (value) {
                      final now = DateTime.now();
                      model.closeDate = DateTime(now.year, now.month, value?.toInt() ?? 0);
                    },
                  ))
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: AmountInput(
                value: model.budget,
                onChanged: (value) => model.budget = value,
                validator: (value) => widget.validator.amount(value),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? CardFormSkeleton() : _formWidget();
  }
}