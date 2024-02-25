import 'package:ebisu/modules/layout/core/domain/main_action.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/dialogs/select_dialog.dart';
import 'package:flutter/material.dart';


class MainActionButton extends StatelessWidget {
  final Map<MainAction, VoidCallback> _actions;

  MainActionButton(this._actions, {super.key});

  Future<MainAction?> _showMainActions(BuildContext context) async {
    final options = [
      SelectOption("Ativo", MainAction.ADD_INCOME,
          icon: Icon(
            Icons.monetization_on,
            color: Colors.green,
          )
      ),
      SelectOption("Despesa", MainAction.ADD_EXPENSE,
          icon: Icon(
            Icons.money_off,
            color: Colors.red,
          )
      )
    ];

    return await showSelectDialog(
        context: context,
        title: "Adicionar",
        options: options,
       appendix: "Selecione o que deseja adicionar!"
    );
  }

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final action = await _showMainActions(context);
        if(action != null) {
          _actions[action]?.call();
        }
      },
      tooltip: "Adicionar",
      child: Icon(Icons.add),
      elevation: 2.0,
    );
  }

}