import 'dart:async';

import 'package:ebisu/configuration/Application/GetSheetId.dart';
import 'package:ebisu/configuration/Application/StoreSheetId.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:flutter/material.dart';

class SheetIdConfiguration extends StatefulWidget {
  final InputFormDecorator decorator = InputFormDecorator();


  Widget build(BuildContext context, _SheetIdConfigurationState state) {
    return ListTile(
      title: TextField(
        controller: TextEditingController(text: state.sheetId),
        onSubmitted: state.storeSheetId,
        decoration: decorator.textForm('Sheet Id', 'Coloque o id da planilha de escolha.'),
      )
    );
  }

  @override
  State<StatefulWidget> createState() => _SheetIdConfigurationState();
}

class _SheetIdConfigurationState extends State<SheetIdConfiguration>  with DispatchesCommands {
  String? sheetId;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _setSheetId();
  }

  void _setSheetId () async {
    String? id = await dispatch(new GetSheetIdCommand());
    setState(() {
      sheetId = id;
    });
  }

  onSheetIdChanged(String? sheetId) {
    if (_debounce != null && _debounce!.isActive) {
      _debounce!.cancel();
    }
    _debounce = Timer(Duration(milliseconds: 3000), () => storeSheetId(sheetId));
  }

  void storeSheetId(String? sheetId) async {
    if (sheetId != null) {
      await dispatch(new StoreSheetIdCommand(sheetId: sheetId));
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(content: Text('Sucesso'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,));
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}