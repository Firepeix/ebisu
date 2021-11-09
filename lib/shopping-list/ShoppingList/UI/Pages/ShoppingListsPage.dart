import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/Domain/ExceptionHandler/ExceptionHandler.dart';
import 'package:ebisu/shared/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/shared/UI/Components/Buttons.dart';
import 'package:ebisu/shopping-list/Application/ShoppingListCommands.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/Repositories/ShoppingListRepositoriesInterfaces.dart';
import 'package:ebisu/shopping-list/ShoppingList/Domain/ShoppingList.dart';
import 'package:ebisu/shopping-list/ShoppingList/UI/Components/ShoppingListForm.dart';
import 'package:ebisu/shopping-list/ShoppingList/UI/Components/ShoppingListViewModel.dart';
import 'package:ebisu/src/UI/Components/General/KeyboardAvoider.dart';
import 'package:flutter/material.dart';

class ShoppingListsPage extends AbstractPage {
  @override
  Widget build(BuildContext context) => scaffold(
    context,
    title: 'Listas De Compra',
    body: _ShoppingListsContent(),
    actionButton: ExpandableFab(
      openChild: Icon(Icons.add),
      children: [
        //ActionButton(
        //  onPressed: () => Navigator.pushNamed(context, '/shopping-list/create', arguments: {'type': SHOPPING_LIST_TYPE.BLANK}),
        //  icon: Icon(Icons.insert_drive_file),
        //),
        ActionButton(
          onPressed: () => Navigator.pushNamed(context, '/shopping-list/create', arguments: {'type': SHOPPING_LIST_TYPE.SHEET}),
          icon: Icon(Icons.description),
        )
      ],
    )
  );
}

class _ShoppingListsContent extends StatefulWidget {

  Widget _createShoppingList(int index, ShoppingList list) {
    return Padding(
      padding: index == 0 ? EdgeInsets.zero : EdgeInsets.only(top: 20),
      child: ShoppingListViewModelList(list),
    );
  }

  Widget build (_ShoppingListsContentState state) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 10),
        child: Padding(
          padding: EdgeInsets.only(top: 20),
          child: ListView.builder(
              itemCount: state.lists.length,
              itemBuilder: (_, int index) => _createShoppingList(index, state.lists[index])
          ),
        )
    );
  }

  @override
  State<StatefulWidget> createState() => _ShoppingListsContentState();
}

class _ShoppingListsContentState extends State<_ShoppingListsContent> with DispatchesCommands, DisplaysErrors {
  List<ShoppingList> lists = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    _setInitialState();
  }

  void _setInitialState () async {
    final _lists = await getShoppingLists();
    setState(() {
      lists = _lists;
      loaded = true;
    });
  }

  Future<List<ShoppingList>> getShoppingLists () async {
    try {
      final lists = await dispatch(new GetShoppingListCommand());
      return Future.value(lists);
    } catch (error) {
      displayError(error, context: context);
      return Future.value([]);
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}

class ShoppingListPage extends AbstractPage {
  String get _title => arguments['list'] != null ? (arguments['list'] as ShoppingList).name : 'Placeholder';

  Widget _mount (BuildContext context) {
    ShoppingList? list = arguments['list'] ?? null;
    if (list != null) {
      return _page(context, ShoppingListViewModel(list, scroll), list);
    }

    return Column();
  }

  Widget _page (BuildContext context, ShoppingListViewModel model, ShoppingList list) => SingleChildScrollView(
    physics: NeverScrollableScrollPhysics(),
    child: Container(
      height: MediaQuery.of(context).size.height,
      child: KeyboardAvoider(
        parentController: scroll,
        standardPadding: 12,
          focusPadding: 253,
          autoScroll: true,
          child: Column(
            children: [
              ShoppingListActions(list.id, list.name),
              model
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

class ShoppingListActions extends StatelessWidget with DispatchesCommands, DisplaysErrors {
  final dynamic listId;
  final String name;

  ShoppingListActions(this.listId, this.name);

  Widget build(BuildContext context) => Padding(
    padding: EdgeInsets.symmetric(horizontal: 3),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
            onPressed: () async {
              try {
                showLoading(context);
                final list = await dispatch(new SyncShoppingListCommand(listId, name, ShoppingListSyncType.pull));
                stopLoading(context);
                Navigator.popUntil(context, ModalRoute.withName('/'));
                Navigator.pushNamed(context, '/shopping-list');
                Navigator.pushNamed(context, '/shopping-list/purchases', arguments: {'list': list});
              } catch (error) {
                displayError(error, context: context);
              }
            },
            style: ElevatedButton.styleFrom(primary: Colors.green),
            child: Row(
              children: [
                Padding(padding: EdgeInsets.only(right: 8), child: Icon(Icons.arrow_downward),),
                Text('Sincronizar Planilha')
              ],
            )
        )
      ],
    ),
  );
}

class CreateShoppingListsPage extends AbstractPage with DispatchesCommands, DisplaysErrors {
  final GlobalKey<ShoppingListFormState> _formKey = GlobalKey<ShoppingListFormState>();

  @override
  Widget build(BuildContext context) => scaffold(
      context,
      title: 'Criar Lista de Compra',
      hasDrawer: false,
      body: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Padding(
            padding: EdgeInsets.only(top: 20),
            child: ShoppingListForm(
              formKey: _formKey,
              formType: arguments['type'],
            ),
          )
      ),
      actionButton: FloatingActionButton(
        child: Icon(Icons.check),
        onPressed: () async {
          if (this._formKey.currentState!.validate()) {
            try {
              dismissKeyboard(context);
              final model = this._formKey.currentState!.submit();
              showLoading(context);
              await dispatch(new CreateShoppingListCommand(model));
              showSuccess(context, message: "Lista de compras criada!", onClose: () => Navigator.popAndPushNamed(context, '/shopping-list'));
            } catch (error) {
              displayError(error, context: context);
            }
          }
        }
      )
  );
}
