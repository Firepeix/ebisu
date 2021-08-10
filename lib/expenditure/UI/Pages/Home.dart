import 'package:ebisu/expenditure/Application/ExpenditureCommands.dart';
import 'package:ebisu/expenditure/Domain/ExpenditureSummary.dart';
import 'package:ebisu/shared/Domain/Bus/Command.dart';
import 'package:ebisu/shared/UI/Components/Summaries.dart';
import 'package:ebisu/shared/UI/Components/Title.dart';
import 'package:ebisu/src/Domain/Pages/AbstractPage.dart';
import 'package:flutter/material.dart';

class ExpenditureHomePage extends AbstractPage {
  @override
  Widget build(BuildContext context) {
    return _Content();
  }
}

class _Content extends StatefulWidget {
  Widget _getDefaultScreen () => Padding(
      padding: EdgeInsets.symmetric(vertical: 30, horizontal: 10),
      child: Column()
  );


  Widget _getHomeDashboard (_ContentState state) => Column(
    children: [
      EbisuTitle('Resumo de Credito'),
      CreditSummaries(summaries: state.creditSummaries,),
      EbisuTitle('Resumo de Debito'),
    ],
  );

  Widget build (_ContentState state) {
    return RefreshIndicator(
        child: state.loaded ? _getHomeDashboard(state) : _getDefaultScreen(),
        onRefresh: () async {
          return print(12);
        }
    );
  }

  @override
  State<StatefulWidget> createState() => _ContentState();
}

class _ContentState extends State<_Content> with DispatchesCommands {
  bool loaded = false;
  List<ExpenditureSummary> creditSummaries = [];

  @override
  void initState() {
    super.initState();
    updateHomeState();
  }

  void updateHomeState () async {
    await _setCreditExpendituresSummary();
    setState(() {
      loaded = true;
    });
  }


  Future<void> _setCreditExpendituresSummary ({cacheLess: false}) async {
    final summaries = await dispatch(new GetCreditExpendituresSummariesCommand(cacheLess));
    setState(() {
      this.creditSummaries = summaries;
    });
    return Future.value();
  }

  @override
  Widget build(BuildContext context) => widget.build(this);

}