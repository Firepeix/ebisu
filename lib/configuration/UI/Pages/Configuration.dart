import 'package:ebisu/configuration/UI/Components/CleanCredentials.dart';
import 'package:ebisu/configuration/UI/Components/SheetIdConfiguration.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ConfigurationPage extends AbstractPage {
  @override
  int pageIndex() => 5;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Configurações'),
      ),
      body: ListView(
        padding: EdgeInsets.only(top: 20),
        children: <Widget>[
          Padding(padding: EdgeInsets.only(top: 0), child: SheetIdConfiguration(),),
          CleanCredentials()
        ],
      ),
    );
  }
}
