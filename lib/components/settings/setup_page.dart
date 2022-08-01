import 'package:ebisu/src/UI/General/SetupApp.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart';

class SetupPage extends StatelessWidget {
  const SetupPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewBody(
      title: "Configuração Inicial",
      child: SetupApp(() => Navigator.pop(context)),
    );
  }
}
