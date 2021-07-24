import 'package:ebisu/card/Infrastructure/CardModuleServiceProvider.dart';
import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/Expenditures/Form/ExpenditureForm.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends AbstractPage implements MainButtonPage {
  static const PAGE_INDEX = 1;
  final ExpenditureServiceInterface service = ExpenditureModuleServiceProvider.expenditureService();
  final ExpenditureRepositoryInterface repository = ExpenditureModuleServiceProvider.expenditureRepository();
  final form = ExpenditureForm(cardRepository: CardModuleServiceProvider.cardRepository());

  CreateExpenditurePage({required onChangePageTo}) : super(onChangeTo: onChangePageTo);

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
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(content: Text('Processando'), behavior: SnackBarBehavior.floating));
          this.repository.insert(expenditure).then((value) {
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(SnackBar(content: Text('Sucesso'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,));
            this.onChangeTo!(HomePage.PAGE_INDEX);
          }).catchError((error) {
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(SnackBar(content: Text('Erro' + error.toString()), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
          });
        }
      },
      tooltip: "Salvar Despesa",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }
}