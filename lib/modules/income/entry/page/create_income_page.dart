import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/amount_form_model.dart';
import 'package:ebisu/modules/common/entry/components/amount_form.dart';
import 'package:ebisu/modules/income/core/usecase/create_income_usecase.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class CreateIncomePage extends StatefulWidget implements MainButtonPage, HomeView {
  static const PAGE_INDEX = 3;

  @override
  int pageIndex() => PAGE_INDEX;

  final VoidCallback? onDone;

  const CreateIncomePage({this.onDone});

  @override
  FloatingActionButton getMainButton(BuildContext context, VoidCallback? onPressed) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: "Salvar Ativo",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }

  @override
  State<StatefulWidget> createState() => _CreateIncomePageState();
}

class _CreateIncomePageState extends State<CreateIncomePage> {
  final _useCase = getIt<CreateIncomeUseCase>();

  @override
  void initState() {
    super.initState();
  }

  Future<void> saveIncome(AmountFormModel model) async {
    showLoading(context: context);
    (await _useCase.createIncome(model)).fold(
        success: (_) {
          showSuccess(context: context);
          widget.onDone?.call();
        },
        failure: (error) => handleError(error, context)
    );
  }

  @override
  Widget build(BuildContext context) {
    final features = [
      AmountFormFeature.DATE,
      AmountFormFeature.PAYMENT_TYPE,
      AmountFormFeature.SOURCE,
    ];

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: AmountForm(
          isSourceRequired: true,
          features: features,
          onSaved: (income) => saveIncome(income)
      ),
    );
  }
}