import 'package:ebisu/modules/card/components/card_form.dart';
import 'package:ebisu/modules/card/events/save_card_notification.dart';
import 'package:ebisu/modules/expenditure/events/change_main_button_on_action_notification.dart';
import 'package:ebisu/ui_components/chronos/buttons/float_action_button.dart';
import 'package:ebisu/ui_components/chronos/buttons/simple_fab.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class UpdateCardPage extends StatelessWidget {
  final String _id;
  final String _name;

  const UpdateCardPage(this._id, this._name, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Editar Cartão $_name",
      child: NotificationListener<SaveCardNotification>(
        child: NotificationListener<ChangeMainButtonActionNotification> (
          child: CardForm(),
        ),
      ),
      fab: CFloatActionButton(
          button: SimpleFAB.save(
            () {},
          )
      ),
    );
  }
}

