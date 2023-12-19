import 'package:ebisu/ui_components/chronos/labels/label.dart';
import 'package:flutter/material.dart';

typedef RowData = Map<String, RowValue?>;

class RowValue {
  final String title;
  final double? size;
  final double? width;
  final bool? breakAtSpaces;
  final Alignment alignment;

  RowValue({required title, this.size, this.breakAtSpaces, this.width, this.alignment = Alignment.centerLeft}): this.title = title ?? "-";
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

class SimpleTable<T extends Row> extends StatelessWidget {
  final List<Column> columns;
  final List<T> rows;
  final void Function(T)? onClickItem;

  const SimpleTable({required this.columns, required this.rows, super.key, this.onClickItem});

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
            if(value.width != null) {
              return DataCell(Container(
                alignment: value.alignment,
                child: Text(value.title, style: TextStyle(fontSize: value.size), softWrap: value.breakAtSpaces,),
                width: value.width,
              ),
                onTap: onClickItem == null ? null : () => onClickItem!.call(it)
              );
            }
            return DataCell(Text(value.title, style: TextStyle(fontSize: value.size), softWrap: value.breakAtSpaces,),
                onTap: onClickItem == null ? null : () => onClickItem!.call(it)
            );
          }).toList()
      );
    }
    ).toList();
  }

  @override
  Widget build(BuildContext context) {
    return DataTable(
        horizontalMargin: 0,
        columnSpacing: 10,
        columns: _createColumns(),
        rows: _createRows()
    );
  }
}
