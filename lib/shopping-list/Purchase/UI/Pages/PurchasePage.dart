import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
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
      return _page(context, PurchaseViewModel(purchase));
    }

    return Column();
  }

  Widget _page (BuildContext context, PurchaseViewModel purchase) => purchase;

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
