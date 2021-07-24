import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:ebisu/expenditure/Infrastructure/ExpenditureModuleServiceProvider.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/General/SetupApp.dart';
import 'package:flutter/material.dart';

class HomePage extends AbstractPage {
  final ExpenditureRepositoryInterface repository = ExpenditureModuleServiceProvider.expenditureRepository();
  static const PAGE_INDEX = 0;

  @override
  Widget build(BuildContext context) {
    return Home(this.repository);
  }
}

class Home extends StatefulWidget {
  final ExpenditureRepositoryInterface repository;

  Home(this.repository);

  @override
  State createState() => _HomeState(this.repository);

  Widget build (_HomeState state) {
    return Column(
      children: [
        Visibility(
            visible: state.isSetup == null,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                    padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                    child: CircularProgressIndicator()
                )
              ],
            )
        ),
        Visibility(
            visible: state.isSetup == true,
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
            visible: state.isSetup == false,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 40, horizontal: 30),
                child: SetupApp(() => state._checkSetup())
            )
        )
      ],
    );
  }
}

class _HomeState extends State<Home>{
  final ExpenditureRepositoryInterface repository;
  bool? isSetup;


  @override
  void initState() {
    super.initState();
    _checkSetup();
  }

  void _checkSetup () async {
    final isSetup = await repository.isSetup();
    setState(() {
      this.isSetup = isSetup;
    });
  }

  _HomeState(this.repository);

  @override
  Widget build(BuildContext context) => widget.build(this);

}