import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/General/SetupApp.dart';
import 'package:flutter/material.dart';

class HomePage extends AbstractPage {
  final ExpenditureRepositoryInterface repository = ExpenditureModuleServiceProvider.expenditureRepository();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
       Visibility(
         visible: repository.isSetup(),
         child: Padding(
             padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
             child: Column(
               children: [
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Icon(Icons.paid_outlined, size: 300,)
                   ],
                 ),
                 Row(
                   mainAxisAlignment: MainAxisAlignment.center,
                   children: [
                     Text('Bem Vindo', style: TextStyle(fontSize: 60, fontWeight: FontWeight.w600),)
                   ],
                 )
               ],
             )
         )
       ),
       Visibility(
            visible: !repository.isSetup(),
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: SetupApp()
            )
        )
      ],
    );
  }
}