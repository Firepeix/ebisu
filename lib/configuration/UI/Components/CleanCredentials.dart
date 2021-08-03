import 'package:ebisu/configuration/Application/GetTypes/CleanCredentialsCommand.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:flutter/material.dart';

class CleanCredentials extends StatelessWidget with DispatchesCommands {
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: ElevatedButton(
        onPressed: () async {
          await dispatch(new CleanCredentialsCommand());
          ScaffoldMessengerState messenger = ScaffoldMessenger.of(context);
          messenger.showSnackBar(SnackBar(content: Text('Sucesso'), backgroundColor: Colors.green, behavior: SnackBarBehavior.floating,));
        },
        child: Text("Limpar Credenciais"),
      ),
    );
  }

}