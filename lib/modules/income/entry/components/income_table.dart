import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/income/core/domain/income.dart';
import 'package:ebisu/modules/income/core/usecase/get_incomes_usecase.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart' as D;
import 'package:ebisu/ui_components/chronos/loading/circular_loading.dart';
import 'package:ebisu/ui_components/chronos/table/simple_table.dart' as T;
import 'package:flutter/material.dart';

class IncomeTable extends StatefulWidget {
  final _getIncomeUseCase = getIt<GetIncomesUseCase>();
  final columns = [
    T.Column(id: "source", title: "Fonte"),
    T.Column(id: "name", title: "Descrição"),
    T.Column(id: "value", title: "Valor", align: Alignment.center)
  ];

  IncomeTable({super.key});

  @override
  State<IncomeTable> createState() => _IncomeTableState();
}

class _IncomeTableState extends State<IncomeTable> {
  List<Income> _incomes = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIncomes();
  }

  Future<void> _loadIncomes() async {
    setState(() => isLoading = true);
    final result = await widget._getIncomeUseCase.getIncomes();
    result.fold(
        success: (it) {
          setState(() => _incomes = it);
          setState(() => isLoading = false);
        },
        failure: (err) => handleError(err, context)
    );
  }

  Money _getSumTotal() {
    if(_incomes.isEmpty) {
      return Money(0);
    }

    return _incomes.map((e) => e.amount).reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: isLoading ? MainAxisAlignment.center : MainAxisAlignment.start,
      children: [
        Visibility(
            visible: isLoading,
            child: CircularLoading(),
            replacement: RefreshIndicator(
              onRefresh: () async => await _loadIncomes(),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Column(
                  children: [
                    T.SimpleTable(columns: widget.columns, rows: _incomes,),
                    Divider(height: 1, thickness: 1,),
                    Padding(
                      padding: EdgeInsets.only(right: 8, top: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Label(text: "Total:", mode: LabelMode.NORMAL, size: 22, accent: Colors.black54,),
                          D.MoneyLabel(_getSumTotal())
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
        ),
      ],
    );
  }
}
