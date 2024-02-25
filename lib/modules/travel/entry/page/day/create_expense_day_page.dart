import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/travel/core/service/travel_service.dart';
import 'package:ebisu/modules/travel/entry/page/travel_home_page.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/form/BiFormValue.dart';
import 'package:ebisu/src/UI/Components/Form/InputValidator.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/controllers/date_controller.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/amount_input.dart';
import 'package:ebisu/ui_components/chronos/form/inputs/input.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class CreateExpenseDayPage extends StatelessWidget {
  final _formKey = GlobalKey<_CreateExpenseDayFormState>();
  final _service = getIt<TravelExpenseServiceInterface>();

  CreateExpenseDayPage({Key? key}) : super(key: key);

  void _handleSubmit(BuildContext context) async {
    final values = _formKey.currentState?.submit();
    if(values != null) {
      final result = await _service.createTravelExpenseDay(values.value1, values.value2);
      result.fold(
          success: (_) => routeToPop(context, TravelHomePage(), 2),
          failure: (error) => handleError(error, context)
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Adicionar Dia",
      child: _CreateExpenseDayForm(key: _formKey,),
      fab: CFloatActionButton(button: SimpleFAB(() => _handleSubmit(context), icon: Icons.check,)),
    );
  }
}

class _CreateExpenseDayForm extends StatefulWidget {
  final _Validator validator = _Validator();
  _CreateExpenseDayForm({Key? key}) : super(key: key);

  @override
  State<_CreateExpenseDayForm> createState() => _CreateExpenseDayFormState();
}

class _CreateExpenseDayFormState extends State<_CreateExpenseDayForm> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late DateController controller;
  int? amount;

  BiFormValue<DateTime, Money>? submit () {
    if(validate()) {
      this._formKey.currentState!.save();
      return BiFormValue(controller.date()!, Money(amount!));
    }

    return null;
  }

  bool validate () {
    return this._formKey.currentState!.validate();
  }

  @override
  void initState() {
    super.initState();
    controller = DateController();
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  void handleAmountChange(int? value) {
    setState(() {
      amount = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: Form(key: _formKey, child: Column(
        children: [
          Input(
            keyboardType: TextInputType.number,
            label: "Dia de Viagem",
            controller: controller,
            validator: (value) => widget.validator.date(controller.date()),
          ),
          Padding(
            padding: EdgeInsets.only(top: 16),
            child: AmountInput(
              value: amount,
              onChanged: handleAmountChange,
              onSaved: (value) => amount = value!,
              validator: (value) => widget.validator.amount(value),
            ),
          ),
        ],
      )),
    );
  }
}

class _Validator extends InputValidator{
  String? date (DateTime? value) {
    if (value == null) {
      return 'Esta não é uma data valida!';
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
    return 'Classe da despesa é obrigatório';
  }
}