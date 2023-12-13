import 'package:ebisu/modules/expenditure/Pages/Home.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/src/UI/General/SetupApp.dart';
import 'package:ebisu/ui_components/chronos/layout/home_view.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget implements HomeView {
  static const PAGE_INDEX = 0;

  @override
  int pageIndex() => PAGE_INDEX;

  @override
  State createState() => _HomeState();
}

class _HomeState extends State<HomePage>{
  bool? isSetup = true;


  @override
  void initState() {
    super.initState();
    //_checkSetup();
  }

  void _checkSetup () async {
    final isSetup = await GoogleSheetsRepository.isSetup();
    setState(() {
      this.isSetup = isSetup;
    });
  }

  _HomeState();

  @override
  Widget build(BuildContext context) {
    if (isSetup == true) {
      return PageView(
        children: [
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: ExpenditureHomePage()
          )
        ],
      );
    }
    return Column(
      children: [
        Visibility(
            visible: isSetup == null,
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
            visible: isSetup == false,
            child: Padding(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 10),
                child: SetupApp(() => _checkSetup())
            )
        )
      ],
    );
  }
}