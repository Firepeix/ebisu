import 'package:ebisu/main.dart';
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/expense/core/domain/expense.dart';
import 'package:ebisu/modules/expense/core/usecase/get_expenses_usecase.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:ebisu/ui_components/chronos/labels/money_label.dart';
import 'package:ebisu/ui_components/chronos/loading/circular_loading.dart';
import 'package:ebisu/ui_components/chronos/table/simple_table.dart' as T;
import 'package:flutter/material.dart';

enum ExpenseFilterMode {
  ONLY_INSTALLMENTS,
  ONLY_CARD,
  ONLY_DIRECT;
}

class ExpenseFilter<T> {
  final ExpenseFilterMode mode;
  final T? data;

  ExpenseFilter(this.mode, { this.data });
}

class ExpenseTable extends StatefulWidget {
  final _useCase = getIt<GetExpensesUseCase>();
  final void Function(Expense)? onClickExpense;
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

  ExpenseTable({this.filters, super.key, this.onClickExpense});

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
    Iterable<Expense> expenses = _expenses;


    widget.filters?.forEach((filter) {
      expenses = switch(filter.mode) {
        ExpenseFilterMode.ONLY_DIRECT =>  expenses.where((element) => element.installment == null || element.installment?.current == 1),
        ExpenseFilterMode.ONLY_INSTALLMENTS =>  expenses.where((element) => element.installment != null && element.installment!.current != 1),
        ExpenseFilterMode.ONLY_CARD =>  expenses.where((element) => element.cardId == filter.data),
      };
    });

    return expenses.toList();
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
                columns: widget.filters?.contains((a) => a.mode == ExpenseFilterMode.ONLY_INSTALLMENTS) == true ? widget._installmentColumns : widget._columns,
                rows: _filtered(),
                onClickItem: widget.onClickExpense == null ? null : (Expense e) => widget.onClickExpense!.call(e),
              ),
              Divider(height: 1, thickness: 1,),
              Padding(
                padding: EdgeInsets.only(right: 8, top: 10, bottom: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Label(text: "Total:", mode: LabelMode.NORMAL, size: 22, accent: Colors.black54,),
                    MoneyLabel(_getSumTotal())
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
