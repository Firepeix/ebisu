import 'package:ebisu/card/Infrastructure/CardModuleServiceProvider.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/Expenditures/Form/ExpenditureForm.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends AbstractPage implements MainButtonPage {
  static const PAGE_INDEX = 1;
  final ExpenditureServiceInterface service = ExpenditureModuleServiceProvider.expenditureService();
  final form = ExpenditureForm(
    cardRepository: CardModuleServiceProvider.cardRepository(),
    expenditureRepository: ExpenditureModuleServiceProvider.expenditureRepository(),
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: form
    );
  }

  @override
  FloatingActionButton getMainButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (this.form.stateKey.currentState!.validate()) {
          Expenditure expenditure = this.service.createExpenditure(this.form.submit());
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text('Processing Data')));
        }
      },
      tooltip: "Salvar Despesa",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }
}
