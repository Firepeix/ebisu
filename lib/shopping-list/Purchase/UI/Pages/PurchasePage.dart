import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
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
    body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: _mount(context),
        )
    ),
  );
}
