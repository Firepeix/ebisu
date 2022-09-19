import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/establishment/domain/services/establishment_service.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_form.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/user/domain/services/user_service.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends StatefulWidget implements MainButtonPage, HomeView {
  static const PAGE_INDEX = 1;

  @override
  int pageIndex() => PAGE_INDEX;

  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<ExpenseFormState> _modelState = GlobalKey<ExpenseFormState>();
  final ExpenseServiceInterface service = getIt();
  final NotificationService notificationService = getIt();
  final CardServiceInterface cardService = getIt();
  final UserServiceInterface userServiceInterface = getIt();
  final EstablishmentServiceInterface establishmentServiceInterface = getIt();

  CreateExpenditurePage({required onChangePageTo});


  @override
  FloatingActionButton getMainButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        print(213);
       //if (_form.currentState != null && _form.currentState!.validate() && _modelState.currentState != null) {
       //  _form.currentState?.save();
       //  final result = await service.createExpense(_modelState.currentState!.model);
       //  if(result.isOk()) {
       //    this.onChangeTo?.call(HomePage.PAGE_INDEX);
       //  }
       //}
      },
      tooltip: "Salvar Despesa",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }

  @override
  State<StatefulWidget> createState() => _CreateExpenditurePageState();
}

class _CreateExpenditurePageState extends State<CreateExpenditurePage> {
  List<CardModel> cards = [];
  List<ExpenseSourceModel> beneficiaries = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    await Future.wait([
      _setCards(),
      _setBeneficiaries()
    ]);

    setState(() {
      loaded = true;
    });
  }

  Future<void> _setCards () async {
    cards = await widget.cardService.getCards();
  }


  Future<void> _setBeneficiaries () async {
    final responses = await Future.wait([
      widget.userServiceInterface.getFriends(),
      widget.establishmentServiceInterface.getEstablishments()
    ]);

    beneficiaries = [...responses[0], ...responses[1]];
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget._form,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
          child: loaded ? ExpenseForm(cards, beneficiaries, key: widget._modelState,) : ExpenseFormSkeleton(),
        )
    );
  }
}
