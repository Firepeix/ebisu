import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:flutter/material.dart';

class PurchaseViewModelList extends StatelessWidget {
  final Purchase _purchase;

  PurchaseViewModelList(this._purchase);

  Widget? _icon () => _purchase.wasBought ? Tooltip(
    message: "Item Comprado!",
    child: CircleAvatar(
      backgroundColor: Colors.green,
      radius: 20,
      child: Icon(Icons.tag_faces, size: 25, color: Colors.white,),
  )) : null;

  @override
  Widget build (BuildContext context) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 6),
    leading: _icon(),
    dense: true,
    title: Text(_purchase.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),),
    subtitle: Text(_purchase.amount.description, style: TextStyle(fontSize: 14),),
    onTap: () => Navigator.pushNamed(context, '/shopping-list/purchases/purchase', arguments: {'purchase': _purchase}),
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
  final Purchase? _purchase;

  PurchaseViewModel(this._purchase);

  @override
  Widget build (BuildContext _) => _purchase != null ? _mount() : _mountNotPurchased();

  Widget _mount() => Summary(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 5, top: 10),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(_purchase!.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.w800),),
        Text(_purchase!.amount.description, style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),),
        Padding(
          padding: EdgeInsets.only(top: 5),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(_purchase!.amount.value.real, style: TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w600),),
              Text(_purchase!.total.real, style: TextStyle(fontSize: 24, color: Colors.red, fontWeight: FontWeight.w800),),
            ],
          ),
        )
      ]
  );

  Widget _mountNotPurchased() => Summary(
      padding: EdgeInsets.only(left: 16, right: 16, bottom: 10, top: 10),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.tag_faces, size: 50,),
            Padding(
              padding: EdgeInsets.only(left: 15),
              child: Text("Este item ainda não foi comprado", style: TextStyle(fontSize: 17),),
            )
          ],
        )
      ]
  );
}

abstract class PurchaseBuilder {
  String get name;
  int get quantity;
  AmountType get type;
  int get amount;
}