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
  Widget build (BuildContext _) {
    final list = _PurchasesListView(_purchases);
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: TextFormField(decoration: _decorator.textForm('Item', 'Pesquisar Item', dense: true)),
              flex: 2,
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                      onPressed: () => print(123),
                      child: Text('EXPANDIR', style: TextStyle(fontSize: 16),)
                  ),)
            )
          ],
        ),
        Padding(child: EbisuDivider(), padding: EdgeInsets.only(top: 5, bottom: 5),),
        list
      ],
    );
  }
}

class _PurchasesListView extends StatefulWidget {
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

  Widget build (BuildContext context, _PurchasesListViewState state) {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size.height;
    return SimpleCard(
      height: screenSize - _spaceOccupiedOnScreen - 10,
      child: _purchases.isEmpty ? _buildEmpty() : _buildList()
    );
  }

  @override
  State<StatefulWidget> createState() => _PurchasesListViewState();
}

class _PurchasesListViewState extends State<_PurchasesListView> {
  @override
  Widget build (BuildContext context) => widget.build(context, this);
}

