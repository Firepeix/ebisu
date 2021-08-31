import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/UI/Components/ShoppingListViewModel.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';

class ShoppingListsPage extends AbstractPage {
  final lorem = [
    ShoppingList('Compras Abril', ShoppingListInputAmount(70000)),
    ShoppingList('Compras Março', ShoppingListInputAmount(150000)),
    ShoppingList('Compras Fevereiro', ShoppingListInputAmount(1500000)),
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

  String get _title => arguments['list'] != null ? (arguments['list'] as ShoppingList).name : 'Placeholder';

  Widget _mount (BuildContext context) {
    ShoppingList? list = arguments['list'] ?? null;
    if (list != null) {
      return _page(context, ShoppingListViewModel(list));
    }

    return Column();
  }

  Widget _page (BuildContext context, ShoppingListViewModel list) => SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Container(
      height: MediaQuery.of(context).size.height ,
      child: KeyboardAvoider(
        standardPadding: 12,
          autoScroll: true,
          child: Column(
            children: [
              ShoppingListActions(),
              list
            ],
          )
      ),
    ),
  );

  @override
  Widget build(BuildContext context) => scaffold(
    context,
    title: _title,
    hasDrawer: false,
    body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 10),
          child: _mount(context),
        )
    ),
  );
}

class ShoppingListActions extends StatelessWidget {
  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () => print(123),
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.refresh),),
                Text('Sincronizar Planilha')
              ],
            )
        )
      ],
    ),
  );
}