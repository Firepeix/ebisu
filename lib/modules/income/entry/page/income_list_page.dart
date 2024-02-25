import 'package:ebisu/modules/income/entry/components/income_table.dart';
import 'package:ebisu/ui_components/chronos/bodies/body.dart';
import 'package:ebisu/ui_components/chronos/layout/view_body.dart';
import 'package:flutter/material.dart' as M;

class IncomeListPage extends M.StatelessWidget {
  final int futureMonth;

  const IncomeListPage ({super.key, this.futureMonth = 0});

  @override
  M.Widget build(M.BuildContext context) {
        return ViewBody(
          title: "Ativos Totais",
          body: Body(
            child: M.Container(
              alignment: M.Alignment.topCenter,
              child: IncomeTable(futureMonth: futureMonth,),
            ),
          ),
        );
  }
}
