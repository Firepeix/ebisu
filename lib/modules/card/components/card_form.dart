import 'package:ebisu/modules/card/events/save_card_notification.dart';
import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/modules/expenditure/events/change_main_button_on_action_notification.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/date_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:flutter/material.dart';

class CardForm extends StatefulWidget {
  final validator = const _CardFormValidator();
  final SaveCardModel? model;

  const CardForm ({Key? key, this.model}) : super(key: key);

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


  String? date (DateTime? value) {
    if (isRequired(value)) {
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
    return 'Orçamento é obrigatório';
  }
}


class _CardFormState extends State<CardForm> with TickerProviderStateMixin {
  _CardViewModel model = _CardViewModel();
  GlobalKey<FormState>? _form;

  @override
  void initState() {
    super.initState();
    _form = GlobalKey<FormState>();
    setModel();
  }

  void setMainButtonAction(BuildContext context) {
    final onMainButtonPressed = () async {
      if (_form?.currentState != null && _form!.currentState!.validate()) {
        _form?.currentState?.save();
        context.dispatchNotification(SaveCardNotification(model));
      }
    };
    context.dispatchNotification(ChangeMainButtonActionNotification(onMainButtonPressed));
  }

  void setModel() {
    if (widget.model != null) {
      model = _CardViewModel(
          name: widget.model!.getName(),
          budget: widget.model!.getBudget(),
          dueDate: widget.model!.getDueDate(),
          closeDate: widget.model!.getCloseDate()
      );
    }
  }

  @override
  void dispose() {
    _form = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
              child: DateInput(
                label: "Data de Fechamento",
                initialValue: model.closeDate,
                validator: widget.validator.date,
                onChanged: (value) => model.closeDate = value,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 16),
              child: DateInput(
                label: "Data de Vencimento",
                initialValue: model.dueDate,
                validator: widget.validator.date,
                onChanged: (value) => model.dueDate = value,
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
}