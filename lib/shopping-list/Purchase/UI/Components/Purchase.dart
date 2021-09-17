import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/shopping-list/Purchase/Domain/Purchase.dart';
import 'package:flutter/material.dart';

class PurchaseViewModelList extends StatelessWidget {
  final Purchase _purchase;

  PurchaseViewModelList(this._purchase);

  @override
  Widget build (BuildContext context) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 6),
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
  final Purchase _purchase;

  PurchaseViewModel(this._purchase);

  @override
  Widget build (BuildContext _) => Column(
    children: [
      EbisuTitle('Planejado'),
      Padding(
        padding: EdgeInsets.only(top: 10),
        child: Expanded(
          flex: 1,
          child: Summary(
              children: [
                Text('asd'),
                Text('asd'),
                Row(
                  children: [
                    Text('asd'),
                    Text('asd'),
                  ],
                )
              ]
          ),
        ),
      )
    ],
  );
}