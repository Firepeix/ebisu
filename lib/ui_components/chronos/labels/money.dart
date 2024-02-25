import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:flutter/material.dart';

class Money extends StatelessWidget {
  final int value;
  final Color? color;
  final double size;
  final bool valueBasedColor;
  const Money(this.value, {Key? key, this.color, this.valueBasedColor = false, this.size = 19}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
    toReal(),
    style: TextStyle(
        fontWeight: FontWeight.w700,
        fontSize: size,
        color: _color(context)
    ),
  );

  Color _color(BuildContext context) {
    if (valueBasedColor) {
      return getStrataColor();
    }

    return color ?? Theme.of(context).colorScheme.secondary;
  }

  String toReal() {
    final amount = value >= 0 ? value / 100 : (value / 100) * -1;
    final money = amount.toStringAsFixed(2).split('.');
    return "${value < 0 ? "- ": ""}R\$ ${_addSeparators(money[0], '.')},${money[1]}";
  }

  double toDouble() {
    return value / 100;
  }

  static int? parse(String real) {
    final amount = real.replaceAll(",", "").replaceAll('.', '');
    return int.tryParse(amount);
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

  MoneyStrata get strata {
    if (value == 0) {
      return MoneyStrata.zeroed;
    }

    return value > 0 ? MoneyStrata.positive : MoneyStrata.negative;
  }

  Money operator -(Money? another) {
    if (another == null) {
      return this;
    }

    return Money(value - another.value);
  }

  Color getStrataColor() {
    return Matcher.matchWhen(strata, {
      MoneyStrata.positive: Colors.green.shade800,
      MoneyStrata.zeroed: Colors.blue.shade800,
      MoneyStrata.negative: Colors.red.shade800,
    });
  }
}