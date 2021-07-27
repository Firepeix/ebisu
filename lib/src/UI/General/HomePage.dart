import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:ebisu/src/UI/General/SetupApp.dart';
import 'package:flutter/material.dart';

class HomePage extends AbstractPage {
  static const PAGE_INDEX = 0;

  @override
  Widget build(BuildContext context) {
    return Home();
  }
}

class Home extends StatefulWidget {
  @override
  State createState() => _HomeState();

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
  bool? isSetup;


  @override
  void initState() {
    super.initState();
    _checkSetup();
  }

  void _checkSetup () async {
    final isSetup = await GoogleSheetsRepository.isSetup();
    setState(() {
      this.isSetup = isSetup;
    });
  }

  _HomeState();

  @override
  Widget build(BuildContext context) => widget.build(this);

}