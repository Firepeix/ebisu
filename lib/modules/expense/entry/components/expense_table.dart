import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/expense/core/usecase/get_expenses_usecase.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart' as D;
import 'package:ebisu/ui_components/chronos/loading/circular_loading.dart';
import 'package:ebisu/ui_components/chronos/table/simple_table.dart' as T;
import 'package:flutter/material.dart';

enum ExpenseFilter {
  ONLY_INSTALLMENTS,
  ONLY_DIRECT;
}

class ExpenseTable extends StatefulWidget {
  final _useCase = getIt<GetExpensesUseCase>();
  final List<ExpenseFilter>? filters;

  final _installmentColumns = [
    T.Column(id: "name", title: "Descrição"),
    T.Column(id: "date", title: "Data"),
    T.Column(id: "installment", title: "Parcela"),
    T.Column(id: "value", title: "Valor", align: Alignment.center)
  ];

  final _columns = [
    T.Column(id: "name", title: "Descrição"),
    T.Column(id: "date", title: "Data"),
    T.Column(id: "value", title: "Valor", align: Alignment.center)
  ];

  ExpenseTable({this.filters, super.key});

  @override
  State<ExpenseTable> createState() => _ExpenseTableState();
}

class _ExpenseTableState extends State<ExpenseTable> {
  List<Expense> _expenses = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadExpenses();
  }

  List<Expense> _filtered() {
    if (widget.filters == null) {
      return _expenses;
    }

    if (widget.filters!.contains(ExpenseFilter.ONLY_DIRECT)) {
      return _expenses.where((element) => element.installment == null).toList();
    }

    if (widget.filters!.contains(ExpenseFilter.ONLY_INSTALLMENTS)) {
      return _expenses.where((element) => element.installment != null).toList();
    }

    return _expenses;
  }

  Future<void> _loadExpenses() async {
    setState(() => isLoading = true);
    final result = await widget._useCase.getExpenses();
    result.fold(
        success: (it) {
          setState(() => _expenses = it);
          setState(() => isLoading = false);
        },
        failure: (err) => handleError(err, context)
    );
  }

  Money _getSumTotal() {
    final expenses = _filtered();
    if(expenses.isEmpty) {
      return Money(0);
    }

    return expenses.map((e) => e.amount).reduce((value, element) => value + element);
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: isLoading,
      child: CircularLoading(),
      replacement: RefreshIndicator(
        onRefresh: () async => await _loadExpenses(),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          child: Column(
            children: [
              T.SimpleTable(
                columns: widget.filters?.contains(ExpenseFilter.ONLY_INSTALLMENTS) == true ? widget._installmentColumns : widget._columns,
                rows: _filtered(),
              ),
              Divider(height: 1, thickness: 1,),
              Padding(
                padding: EdgeInsets.only(right: 8, top: 10, bottom: 10),
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
    );
  }
}
