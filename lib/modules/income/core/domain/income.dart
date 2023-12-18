import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/ui_components/chronos/table/simple_table.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

class Income implements Row {
  final String id;
  final String name;
  final Money amount;
  final Moment date;
  final String frequency;
  final Source? source;

  Income({required this.id, required this.name, required this.amount, required this.date, required this.frequency, required this.source});

  @override
  RowData getRowData() {
    return {
      "source": RowValue(title: source?.name,),
      "name": RowValue(title: name,),
      "value": RowValue(title: amount.toReal(), size: 15, breakAtSpaces: false),
    };
  }

}