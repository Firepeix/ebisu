
import 'package:ebisu/shared/UI/Components/EbisuCards.dart';
import 'package:ebisu/shopping-list/Purchase/UI/Components/Purchase.dart';
import 'package:ebisu/shopping-list/Shared/Domain/Purchases.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:flutter/material.dart';

class PurchasesViewModel extends StatefulWidget {
  final InputFormDecorator _decorator = InputFormDecorator();
  final GlobalKey<_PurchasesListViewState> _listKey = GlobalKey<_PurchasesListViewState>();
  final ScrollController _scroll;
  final Purchases _purchases;

  PurchasesViewModel(this._purchases, this._scroll);

  @override
  State<StatefulWidget> createState() => _PurchasesViewModelState();
  Widget build (BuildContext _, _PurchasesViewModelState state) {
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
                      onPressed: () => state.expand(),
                      child: Text(state.expandLabel, style: TextStyle(fontSize: 16),)
                  ),)
            )
          ],
        ),
        Padding(child: EbisuDivider(), padding: EdgeInsets.only(top: 5, bottom: 5),),
        _PurchasesListView(_purchases, _scroll, key: _listKey,)
      ],
    );
  }
}

class _PurchasesViewModelState extends State<PurchasesViewModel> {
  @override
  Widget build (BuildContext context) => widget.build(context, this);
  String expandLabel = 'EXPANDIR';

  void expand () {
    setState(() {
      if (widget._listKey.currentState != null) {
        widget._listKey.currentState!.toggle();
        setState(() {
          expandLabel = widget._listKey.currentState!.isExpanded ? 'ENCOLHER' : 'EXPANDIR';
        });
        return;
      }

      expandLabel = 'EXPANDIR';
    });
  }
}

class _PurchasesListView extends StatefulWidget {
  final Purchases _purchases;
  final double spaceOccupiedOnScreen = 442;
  final ScrollController _scroll;

  _PurchasesListView(this._purchases, this._scroll, {Key? key}) : super(key: key);

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
    return SimpleCard(
        height: state.height,
        child: _purchases.isEmpty ? _buildEmpty() : _buildList()
    );
  }

  @override
  State<StatefulWidget> createState() => _PurchasesListViewState();
}

class _PurchasesListViewState extends State<_PurchasesListView> {
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  @override
  Widget build (BuildContext context) => widget.build(context, this);

  double get height {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size.height;
    return !_isExpanded ? screenSize - widget.spaceOccupiedOnScreen - 10 : screenSize;
  }

  void toggle () {
    final shouldExpand = !_isExpanded;
    if (shouldExpand) {
      _expand();
      return;
    }
    _shrink();
  }

  void _expand () {
    setState(() {
      _isExpanded = true;
      _scroll();
    });
  }

  void _scroll ({max: true}) {
    widget._scroll.position.animateTo(
      max ? 290  : 0,
      duration: Duration(milliseconds: 400),
      curve: Curves.easeOut,
    );
  }

  void _shrink () {
    setState(() {
      _isExpanded = false;
      _scroll(max: false);
    });
  }
}

