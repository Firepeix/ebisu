import 'package:ebisu/main.dart';
import 'package:ebisu/modules/card/components/card_form.dart';
import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/events/save_card_notification.dart';
import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/ui_components/chronos/actions/tap.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class UpdateCardPage extends StatelessWidget {
  final String _id;
  final String _name;
  final CardServiceInterface service = getIt();
  final OnTap<VoidCallback> _onSubmit = OnTap();

  UpdateCardPage(this._id, this._name, {Key? key}) : super(key: key);

  Future<void> updateCard(BuildContext context, SaveCardModel model)  async {
    final result = await service.updateCard(_id, model);
    if (result.isOk()) {
      routeToBack(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Editar Cartão $_name",
      child: NotificationListener<SaveCardNotification>(
        child: CardForm(cardId: _id, service: service, submit: _onSubmit,),
        onNotification: (notification) {
          updateCard(context, notification.model);
          return true;
        },
      ),
      fab: CFloatActionButton(
          button: SimpleFAB.save(() => {
            _onSubmit.action?.call()
          })
      ),
    );
  }
}