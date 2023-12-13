
enum MoneyStrata {
  positive,
  zeroed,
  negative
}

class Money  {
  final int value;
  const Money(this.value);


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
}