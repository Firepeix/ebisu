import 'package:ebisu/shared/UI/Components/Texts/HighlightTexts.dart';
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
    trailing: HighlightedAmountText(_list.input.real),
  );

}