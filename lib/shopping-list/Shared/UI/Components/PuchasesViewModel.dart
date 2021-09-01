import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
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
      ),
      Padding(child: EbisuDivider(), padding: EdgeInsets.only(top: 5, bottom: 5),),
      _PurchasesListView(_purchases)
    ],
  );
}

class _PurchasesListView extends StatelessWidget {
  final Purchases _purchases;
  _PurchasesListView(this._purchases);

  final double _spaceOccupiedOnScreen = 442;
  Widget _buildPurchase (_, int index) => PurchaseViewModelList(_purchases[index]);

  Widget _buildEmpty () => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error, size: 35,),
      Padding(padding: EdgeInsets.only(top: 10), child: Text('Nenhuma compra encontrada'),)
    ],
  );

  Widget _buildList () => ListView.builder(
    itemBuilder: _buildPurchase,
    itemCount: _purchases.length,
  );

  @override
  Widget build (BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size.height;
    return SimpleCard(
      height: screenSize - _spaceOccupiedOnScreen,
      child: _purchases.isEmpty ? _buildEmpty() : _buildList()
    );
  }
}

