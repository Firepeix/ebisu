import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/shared/utils/matcher.dart';
import 'package:flutter/material.dart';

class MoneyLabel extends StatelessWidget {
  final Money value;
  final Color? color;
  final double size;
  final bool valueBasedColor;
  const MoneyLabel(this.value, {Key? key, this.color, this.valueBasedColor = false, this.size = 19}) : super(key: key);

  @override
  Widget build(BuildContext context) => Text(
    value.toReal(),
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

  Color getStrataColor() {
    return Matcher.matchWhen(value.strata, {
      MoneyStrata.positive: Colors.green.shade800,
      MoneyStrata.zeroed: Colors.blue.shade800,
      MoneyStrata.negative: Colors.red.shade800,
    });
  }
}