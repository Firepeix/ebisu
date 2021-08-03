import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/configuration/Application/ActiveSheets.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/src/UI/Components/Form/InputDecorator.dart';
import 'package:flutter/material.dart';

class ActiveSheetConfiguration extends StatefulWidget {
  final InputFormDecorator decorator = InputFormDecorator();
  late final ActiveSheetOptions _options;
  ActiveSheetConfiguration ({required CardClass type}) {
    _options = ActiveSheetOptions(type: type);
  }

  Widget build(BuildContext context, _SheetIdConfigurationState state) {
    return ListTile(
      title: TextField(
        controller: TextEditingController(text: state.name),
        onSubmitted: state.storeActiveSheetName,
        decoration: decorator.textForm(_options.label, 'Coloque o nome da folha deste tipo.'),
      )
    );
  }

  @override
  State<StatefulWidget> createState() => _SheetIdConfigurationState(options: _options);
}

class _SheetIdConfigurationState extends State<ActiveSheetConfiguration> with DispatchesCommands {
  String? name = '';
  final ActiveSheetOptions options;

  _SheetIdConfigurationState({required this.options});

  @override
  void initState() {
    super.initState();
    _setName();
  }

  void _setName () async {
    String? id = await dispatch(new GetActiveSheetNameCommand(type: options.type));
    setState(() {
      name = id;
    });
  }

  void storeActiveSheetName(String? sheetName) async {
    if (sheetName != null) {
      await dispatch(new StoreActiveSheetNameCommand(sheetName: sheetName, type: options.type));
      ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
      messenger.showSnackBar(SnackBar(content: Text('Sucesso'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,));
    }
  }

  @override
  Widget build(BuildContext context) => widget.build(context, this);
}

class ActiveSheetOptions {
  late final CardClass _type;
  ActiveSheetOptions({required CardClass type}) {
    _type = type;
  }

  String get label => _type == CardClass.DEBIT ? 'Planilha de Debito' : 'Planilha de Credito';
  CardClass get type => _type;
}