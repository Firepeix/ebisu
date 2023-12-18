import 'dart:async';

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
              child: TextFormField(onChanged: state.handleSearch, decoration: _decorator.textForm('Item', 'Pesquisar Item', dense: true)),
              flex: 2,
            ),
            Expanded(
                child: Padding(
                  padding: EdgeInsets.only(left: 15),
                  child: ElevatedButton(
                      onPressed: state.handleExpandButtonAction(),
                      child: Text(state.expandLabel, style: TextStyle(fontSize: 16),)
                  ),)
            )
          ],
        ),
        Padding(child: EbisuDivider(), padding: EdgeInsets.only(top: 5, bottom: 5),),
        _PurchasesListView(_purchases, _scroll, key: _listKey, query: state._query,)
      ],
    );
  }
}

class _PurchasesViewModelState extends State<PurchasesViewModel> {
  String _query = '';

  @override
  Widget build (BuildContext context) => widget.build(context, this);
  String expandLabel = 'EXPANDIR';

  void handleSearch (String query) {
    setState(() {
      _query = query;
    });
  }

  bool _keyboardIsShown () {
    final binding = WidgetsBinding.instance;
    if (binding != null) {
      final viewInsets = EdgeInsets.fromWindowPadding(binding.window.viewInsets, binding.window.devicePixelRatio);
      return viewInsets.bottom > 0.0;
    }

    return false;
  }

  VoidCallback? handleExpandButtonAction () {
    if (_keyboardIsShown()) {
      return null;
    }

    return () => expand();
  }

  void expand ({Duration? waitUntil}) {
    setState(() {
      if (widget._listKey.currentState != null) {
        widget._listKey.currentState!.toggle(waitUntil);
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
  final String query;

  _PurchasesListView(this._purchases, this._scroll, {Key? key, this.query = ''}) : super(key: key);


  Widget _buildEmpty () => Column(
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      Icon(Icons.error, size: 35,),
      Padding(padding: EdgeInsets.only(top: 10), child: Text('Nenhuma compra encontrada'),)
    ],
  );

  Widget _buildList (Purchases purchases) => ListView.builder(
    itemBuilder: (_, int index) => PurchaseViewModelList(purchases[index]),
    itemCount: purchases.length,
  );

  Widget build (BuildContext context, _PurchasesListViewState state) {
    return SimpleCard(
        height: state.height,
        child: _purchases.isEmpty ? _buildEmpty() : _buildList(state.search(query, _purchases))
    );
  }

  @override
  State<StatefulWidget> createState() => _PurchasesListViewState();
}

class _PurchasesListViewState extends State<_PurchasesListView> {
  Purchases? purchases;
  bool _isExpanded = false;
  bool get isExpanded => _isExpanded;

  @override
  Widget build (BuildContext context) {
    return widget.build(context, this);
  }

  Purchases search (String query, Purchases original) {
    if (query != '') {
      return original.filterByName(query);
    }

    return original;
  }

  double get height {
    final mediaQuery = MediaQuery.of(context);
    final screenSize = mediaQuery.size.height;
    return !_isExpanded ? screenSize - widget.spaceOccupiedOnScreen - 10 : screenSize;
  }

  void toggle (Duration? waitUntil) {
    final shouldExpand = !_isExpanded;
    if (shouldExpand) {
      _expand(waitUntil);
      return;
    }
    _shrink();
  }

  void _expand (Duration? waitUntil) {
    setState(() {
      _isExpanded = true;
      if (waitUntil != null) {
        Timer(waitUntil, () => _scroll());
        return;
      }
      _scroll();
    });
  }

  void _scroll ({max =  true}) {
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

