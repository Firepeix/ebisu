import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shared/UI/Components/Texts/HighlightTexts.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/shopping-list/Shared/UI/Components/PuchasesViewModel.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:flutter/material.dart';

class ShoppingListViewModelList extends StatelessWidget {
  final ShoppingList _list;
  ShoppingListViewModelList(this._list);
  @override
  Widget build(BuildContext context) => ListTile(
    contentPadding: EdgeInsets.symmetric(horizontal: 6),
    shape: RoundedRectangleBorder(
        side: BorderSide(color: Colors.grey.shade400, width: 0.5),
        borderRadius: BorderRadius.all(Radius.circular(5))
    ),
    title: Text(_list.name, style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),),
    onTap: () => Navigator.pushNamed(context, '/shopping-list/purchases', arguments: {'list': _list}),
    trailing: HighlightedAmountText(_list.input.real),
  );
}

class ShoppingListViewModel extends StatelessWidget {
  final ShoppingList _list;
  final bool showPurchases;
  final ScrollController _scroll;

  ShoppingListViewModel(this._list, this._scroll, {this.showPurchases =  true});

  @override
  Widget build(BuildContext context) => Column(
    children: [
      _ShoppingListSummary(_list),
      Padding(padding: EdgeInsets.only(top: 10), child: PurchasesViewModel(_list.purchases, _scroll),),
    ],
  );
}

class _ShoppingListSummary extends StatelessWidget {
  final ShoppingList _list;
  _ShoppingListSummary(this._list);

  @override
  Widget build(BuildContext context) => Summary(
      children: [
        Row(
          children: [
            Expanded(child: _ShoppingListSummaryProjection(_list.totalBudgeted.real, (_list.input - _list.totalBudgeted).real)),
            VerticalSummaryDivider(height: 166,),
            Expanded(child: _ShoppingListSummaryProjection(_list.totalPurchased.real, (_list.input - _list.totalPurchased).real, title: 'Realizado',))
          ],
        ),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _ShoppingListSummaryAbsolutes('Entrada', _list.input.real),
              _ShoppingListSummaryAbsolutes('Diferença Plan./Real.', _list.totalDifference.real),
              _ShoppingListSummaryAbsolutes('Previsão', _list.projection.real),
            ],
          ),
        ),
      ]
  );
}

class _ShoppingListSummaryProjection extends StatelessWidget {
  final String _upper;
  final String _lower;
  final String title;

  _ShoppingListSummaryProjection(this._upper, this._lower, {this.title =  'Planejado'});
  @override
  Widget build(BuildContext context) => Column(
    children: [
      SummarySection(
          children: [
            EbisuSubTitle(title, size: 24,),
          ]
      ),
      SummaryDivider(),
      SummarySection(
          children: [
            EbisuSubTitle('Total', size: 15,),
            EbisuSubTitle(_upper, size: 24,),
            EbisuSubTitle('Restante', size: 15,),
            EbisuSubTitle(_lower, size: 24,),
          ]
      ),
      SummaryDivider(),
    ],
  );
}

class _ShoppingListSummaryAbsolutes extends StatelessWidget {
  final String _upper;
  final String _lower;

  _ShoppingListSummaryAbsolutes(this._upper, this._lower);
  @override
  Widget build(BuildContext context) => Column(
    children: [
      EbisuSubTitle(_upper, size: 15,),
      EbisuSubTitle(_lower, size: 20,),
    ],
  );
}