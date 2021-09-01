import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:flutter/material.dart';

class PurchaseViewModelList extends StatelessWidget {
  final Purchase _purchase;

  PurchaseViewModelList(this._purchase);

  @override
  Widget build (BuildContext _) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 6),
    dense: true,
    //shape: Border(
    //  top: BorderSide(color: Colors.grey.shade400, width: 0.5),
    //  bottom: BorderSide(color: Colors.grey.shade400, width: 0.5),
    //),
    title: Text(_purchase.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
    trailing: Text(_purchase.boughtTotal.real, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 18),),
  );
}