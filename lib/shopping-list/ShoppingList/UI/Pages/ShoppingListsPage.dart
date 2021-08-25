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
    context,
    title: 'Listas De Compra',
    body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
              itemCount: lorem.length,
              itemBuilder: _createShoppingList
          ),
        )
    ),
  );
}

class ShoppingListPage extends AbstractPage {
  Widget _mount () {
    ShoppingList? list = arguments['list'] ?? null;
    if (list != null) {
      return ShoppingListViewModel(list);
    }

    return Column();
  }

  @override
  Widget build(BuildContext context) => scaffold(
    context,
    title: 'Listas asdsada',
    hasDrawer: false,
    body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: _mount(),
        )
    ),
  );
}