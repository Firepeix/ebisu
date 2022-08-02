import 'package:ebisu/shared/services/notification_service.dart';
import 'package:ebisu/ui_components/chronos/buttons/button.dart';
import 'package:ebisu/ui_components/chronos/labels/subtitle.dart';
import 'package:ebisu/ui_components/chronos/labels/title.dart';
import 'package:flutter/material.dart';

class ConfirmDialog extends StatelessWidget {
  final String appendix;

  const ConfirmDialog({this.appendix = "Isto não poderá ser revertido!", Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 200,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Column(
              children: [
                ETitle("Tem certeza ?"),
                Padding(padding: EdgeInsets.only(top: 5), child: Subtitle(text: appendix),)
              ],
            ),
            Padding(
                padding: EdgeInsets.only(top: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Button(
                    wide: true,
                    text: "Sim",
                    onPressed: () => Navigator.pop(context, ConfirmResult.confirmed),
                  ),
                  Padding(padding: EdgeInsets.symmetric(horizontal: 25)),
                  Button(
                    wide: true,
                    invert: true,
                    text: "Não",
                    onPressed: () => Navigator.pop(context, ConfirmResult.cancelled),
                  )
                ],),
            )
          ],
        ),
      ),
    );
  }
}
