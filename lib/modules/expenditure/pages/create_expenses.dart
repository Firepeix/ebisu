import 'package:ebisu/modules/expenditure/components/expense/expense_form.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends AbstractPage implements MainButtonPage {
  static const PAGE_INDEX = 1;
  //final GlobalKey<ExpenditureFormState> _formKey = GlobalKey<ExpenditureFormState>();

  //CreateExpenditurePage({required onChangePageTo}) : super(onChangeTo: onChangePageTo);

  @override
  Widget build(BuildContext context) {
    return Content();
  }

  @override
  FloatingActionButton getMainButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
       //if (this._formKey.currentState!.validate()) {
       //  final model = this._formKey.currentState!.submit();
       //  //final expenditure = this.service.createExpenditure(model);
       //  ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
       //  messenger.showSnackBar(SnackBar(content: Text('Processando'), behavior: SnackBarBehavior.floating));
       //  this.onChangeTo!(HomePage.PAGE_INDEX);
       //  messenger.hideCurrentSnackBar();
       //  messenger.showSnackBar(SnackBar(content: Text('Sucesso'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,));
       //  //this.repository.insert(expenditure).catchError((error) {
       //  //  messenger.hideCurrentSnackBar();
       //  //  messenger.showSnackBar(SnackBar(content: Text('Erro' + error.toString()), backgroundColor: Colors.red, behavior: SnackBarBehavior.floating));
       //  //});
       //}
      },
      tooltip: "Salvar Despesa",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }
}


class Content extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> {
  Map<int, String> cardTypes = {};
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    await Future.wait([
      _setCardTypes()
    ]);

    setState(() {
      loaded = true;
    });
  }

  Future<void> _setCardTypes () async {

  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: loaded ? ExpenseForm() : ExpenseFormSkeleton(),
    );
  }
}
