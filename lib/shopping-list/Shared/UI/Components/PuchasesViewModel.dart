import 'package:ebisu/shopping-list/Shared/Domain/Purchases.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:flutter/material.dart';

class PurchasesViewModel extends StatelessWidget {
  final InputFormDecorator _decorator = InputFormDecorator();

  final Purchases _purchases;

  PurchasesViewModel(this._purchases);

  @override
  Widget build (BuildContext _) => Column(
    children: [
      Row(
        children: [
          Expanded(
            child: TextFormField(decoration: _decorator.textForm('Item', 'Pesquisar Item', dense: true)),
          )
        ],
      )
    ],
  );
}

