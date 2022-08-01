import 'package:flutter/material.dart';

class Money extends StatelessWidget {
  final int value;
  const Money(this.value, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
    toReal(),
    style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: 19,
        color: Theme.of(context).colorScheme.secondary
    ),
  );

  String toReal() {
    final amount = value >= 0 ? value / 100 : (value / 100) * -1;
    final money = amount.toStringAsFixed(2).split('.');
    final isNegative = value >= 0 ? '' : '-';
    return "R\$ $isNegative${_addSeparators(money[0], '.')},${money[1]}";
  }

  String _addSeparators(String src, String divider) {
    List<String> newStr = [];
    int step = 3;
    for (int i = src.length; i > 0; i -= step) {
      newStr.insert(0, src.substring( i < step ? 0 : i - step, i));
      if (i > 3) {
        newStr.insert(0, divider);
      }
    }
    return newStr.join('');
  }
}