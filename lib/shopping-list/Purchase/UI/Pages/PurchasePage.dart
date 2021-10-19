import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/ExceptionHandler/ExceptionHandler.dart';
import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/UI/Components/Buttons.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/PurchaseForm.dart';
import 'package:flutter/material.dart';

class PurchasePage extends AbstractPage {
  String get _title {
    String title = 'Compra';
    if (arguments['purchase'] != null) {
      Purchase _purchase = arguments['purchase'];
      title += ' - ${_purchase.name}';
    }
    return title;
  }

  Widget _mount (BuildContext context) {
    Purchase? purchase = arguments['purchase'] ?? null;
    if (purchase != null) {
      return _page(context, purchase);
    }

    return Column();
  }

  void onSubmitPurchased(BuildContext context, PurchaseModel model) {
    //Navigator.popUntil(context, ModalRoute.withName('/shopping-list/purchases'));
    //Navigator.pushNamed(context, '/shopping-list/purchases/purchase', arguments: {'purchase': _purchase})
  }

  Widget _page (BuildContext context, Purchase purchase) => Column(
    children: [
      EbisuTitle('Planejado'),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: PurchaseViewModel(purchase),
      ),
      Padding(
        padding: EdgeInsets.only(top: 27),
        child: Column(
          children: [
            EbisuTitle('Comprado'),
            Padding(
              padding: EdgeInsets.only(top: 10),
              child: PurchaseViewModel(purchase.purchased),
            )
          ],
        ),
      )
    ],
  );

  @override
  Widget build(BuildContext context) => scaffold(
    context,
    title: _title,
    hasDrawer: false,
    actionButton: ExpandableFab(
      openChild: Icon(Icons.menu),
      children: [
        //ActionButton(
        //  onPressed: () => Navigator.pushNamed(context, '/shopping-list/create', arguments: {'type': SHOPPING_LIST_TYPE.BLANK}),
        //  icon: Icon(Icons.insert_drive_file),
        //),
        ActionButton(
          onPressed: () {
            Navigator.pushNamed(context, '/shopping-list/purchases/purchase/create', arguments: {'onSubmit': (PurchaseModel model) => onSubmitPurchased(context, model)});
          },
          icon: Icon(Icons.add),
        )
      ],
    ),
    body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: _mount(context),
        )
    ),
  );
}


class CreatePurchasePage extends AbstractPage with DispatchesCommands, DisplaysErrors {
  final GlobalKey<PurchaseFormState> _formKey = GlobalKey<PurchaseFormState>();

  @override
  Widget build(BuildContext context) => scaffold(
      context,
      title: 'Adicionar Compra',
      hasDrawer: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: PurchaseForm(
              formKey: _formKey,
            ),
          )
      ),
      actionButton: FloatingActionButton(
          child: Icon(Icons.check),
          onPressed: () async {
            if (this._formKey.currentState!.validate()) {
              try {
               dismissKeyboard(context);
               final model = this._formKey.currentState!.submit();
               if(arguments['onSubmit'] != null) {
                 arguments['onSubmit'](model);
               }
              } catch (error) {
                displayError(error, context: context);
              }
            }
          }
      )
  );
}