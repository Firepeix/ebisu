import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:flutter/material.dart';

class PurchaseViewModelList extends StatelessWidget {
  final Purchase _purchase;

  PurchaseViewModelList(this._purchase);

  @override
  Widget build (BuildContext _) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 6),
    dense: true,
    title: Text(_purchase.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
    subtitle: Text(_purchase.amount.description, style: TextStyle(fontSize: 14),),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(padding: EdgeInsets.only(top: 7), child: Text(_purchase.boughtTotal.real, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),),
        Text(_purchase.amount.value.real, style: TextStyle(color: Colors.grey, fontSize: 14),)
      ],
    ),
  );
}

class PurchaseViewModel extends StatelessWidget {
  final Purchase _purchase;

  PurchaseViewModel(this._purchase);

  @override
  Widget build (BuildContext _) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 6),
    dense: true,
    title: Text(_purchase.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
    subtitle: Text(_purchase.amount.description, style: TextStyle(fontSize: 14),),
    trailing: Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(padding: EdgeInsets.only(top: 7), child: Text(_purchase.boughtTotal.real, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),),
        Text(_purchase.amount.value.real, style: TextStyle(color: Colors.grey, fontSize: 14),)
      ],
    ),
  );
}