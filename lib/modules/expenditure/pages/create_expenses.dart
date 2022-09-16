import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/establishment/domain/services/establishment_service.dart';
import 'package:ebisu/modules/expenditure/components/expense/expense_form.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/user/domain/services/user_service.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/Components/Nav/MainButtonPage.dart';
import 'package:ebisu/src/UI/General/HomePage.dart';
import 'package:flutter/material.dart';

class CreateExpenditurePage extends AbstractPage implements MainButtonPage {
  static const PAGE_INDEX = 1;
  final GlobalKey<FormState> _form = GlobalKey<FormState>();
  final GlobalKey<ExpenseFormState> _modelState = GlobalKey<ExpenseFormState>();
  final ExpenseServiceInterface service = getIt();
  final NotificationService notificationService = getIt();
  CreateExpenditurePage({required onChangePageTo}) : super(onChangeTo: onChangePageTo);

  @override
  Widget build(BuildContext context) {
    return Form(child: Content(_modelState), key: _form,);
  }

  @override
  FloatingActionButton getMainButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
       if (_form.currentState != null && _form.currentState!.validate() && _modelState.currentState != null) {
         _form.currentState?.save();
         final result = await service.createExpense(_modelState.currentState!.model);
         if(result.isSuccessful()) {
           this.onChangeTo?.call(HomePage.PAGE_INDEX);
         }
       }
      },
      tooltip: "Salvar Despesa",
      child: Icon(Icons.check),
      elevation: 2.0,
    );
  }
}


class Content extends StatefulWidget {
  final CardServiceInterface cardService = getIt();
  final UserServiceInterface userServiceInterface = getIt();
  final EstablishmentServiceInterface establishmentServiceInterface = getIt();
  final GlobalKey<ExpenseFormState> _modelState;

  Content(this._modelState);

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<Content> {
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
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
      child: loaded ? ExpenseForm(cards, beneficiaries, key: widget._modelState,) : ExpenseFormSkeleton(),
    );
  }
}
