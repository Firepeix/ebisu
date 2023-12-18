import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

typedef RowData = Map<String, RowValue?>;

class RowValue {
  final String title;
  final double? size;
  final bool? breakAtSpaces;

  RowValue({required title, this.size, this.breakAtSpaces}): this.title = title ?? "-";
}

class Column {
  final String id;
  final String title;
  final Alignment align;

  Column({required this.id, required this.title, this.align = Alignment.centerLeft});
}

abstract class Row {
  RowData getRowData();
}

class SimpleTable extends StatelessWidget {
  final List<Column> columns;
  final List<Row> rows;

  const SimpleTable({required this.columns, required this.rows, super.key});

  List<DataColumn> _createColumns() {
    return columns.map((it) {
      return DataColumn(
          label: Expanded(
            child: Container(
              alignment: it.align,
              child: Label.accent(text: it.title),
            ),
          )
      );
    }
    ).toList();
  }

  List<DataRow> _createRows() {
    return rows.map((it) {
      final rowData = it.getRowData();

      return DataRow(
          cells: columns.map((column) {
            final value = rowData[column.id] ?? RowValue(title: "-");
            if(value.breakAtSpaces == false) {
              return DataCell(Container(
                alignment: Alignment.center,
                child: Text(value.title, style: TextStyle(fontSize: value.size), softWrap: value.breakAtSpaces,),
                width: 85,
              ));
            }
            return DataCell(Text(value.title, style: TextStyle(fontSize: value.size), softWrap: value.breakAtSpaces,));
          }).toList()
      );
    }
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        horizontalMargin: 0,
        columns: _createColumns(),
        rows: _createRows()
    );
  }
}
