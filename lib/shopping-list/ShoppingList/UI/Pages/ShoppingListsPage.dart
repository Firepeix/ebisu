import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/UI/Components/ShoppingListViewModel.dart';
import 'package:flutter/material.dart';

class ShoppingListsPage extends AbstractPage {
  final lorem = [
    ShoppingList('Compras Abril', ShoppingListInputAmount(70000)),
    ShoppingList('Compras Março', ShoppingListInputAmount(60000)),
    ShoppingList('Compras Fevereiro', ShoppingListInputAmount(60000)),
    ShoppingList('Compras Janeiro', ShoppingListInputAmount(30000)),
  ];

  Widget _createShoppingList(_, int index) {
    return Padding(
      padding: index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 20),
      child: ShoppingListViewModelList(lorem[index]),
    );
  }


  @override
  Widget build(BuildContext context) => scaffold(
      context, 'Listas De Compra',
      Padding(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: ListView.builder(
            itemCount: lorem.length,
            itemBuilder: _createShoppingList
          ),
        )
      ),
  );
}