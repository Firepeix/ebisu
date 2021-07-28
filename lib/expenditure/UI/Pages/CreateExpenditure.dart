import 'package:ebisu/card/Application/GetTypes/GetCardTypesCommand.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Domain/Services/ExpenditureServiceInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/Expenditures/Form/ExpenditureForm.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends AbstractPage implements MainButtonPage {
  static const PAGE_INDEX = 1;
  final ExpenditureServiceInterface service = ExpenditureModuleServiceProvider.expenditureService();
  final ExpenditureRepositoryInterface repository = ExpenditureModuleServiceProvider.expenditureRepository();
  //final Content _content = Content();
  final GlobalKey<ExpenditureFormState> _formKey = GlobalKey<ExpenditureFormState>();

  CreateExpenditurePage({required onChangePageTo}) : super(onChangeTo: onChangePageTo);

  @override
  Widget build(BuildContext context) {
    return Content(formKey: _formKey);
  }

  @override
  FloatingActionButton getMainButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        if (this._formKey.currentState!.validate()) {
          final model = this._formKey.currentState!.submit();
          final expenditure = this.service.createExpenditure(model);
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(content: Text('Processando'), behavior: SnackBarBehavior.floating));
          this.onChangeTo!(HomePage.PAGE_INDEX);
          this.repository.insert(expenditure).then((value) {
            messenger.hideCurrentSnackBar();
            messenger.showSnackBar(SnackBar(content: Text('Sucesso'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,));
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


class Content extends StatefulWidget {
  final GlobalKey<ExpenditureFormState> formKey;

  Content({ required this.formKey });

  Widget build (_ContentState state) {
    return Visibility(
      visible: state.loaded,
      child: Padding(
        padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
        child: ExpenditureForm(
          formKey: formKey,
          cardTypes: state.cardTypes,
        ),
    ));
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> with DispatchesCommands {
  Map<int, String> cardTypes = {};
  bool loaded = false;

  void onMainButtonPress () {
    print('asd');
  }

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
    final types = await dispatch(new GetCardTypesCommand());
    setState(() {
      cardTypes = types;
    });
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}
