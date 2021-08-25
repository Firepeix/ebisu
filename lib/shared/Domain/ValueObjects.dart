class IntValueObject extends Comparable<int> {
  late int value;
  IntValueObject(this.value);

  static int integer (String value) => (double.parse(value) * 100).toInt();

  String get real {
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

  double get asDouble {
    final amount = value / 100;
    return double.parse(amount.toStringAsFixed(2));
  }


  @override
  int compareTo(int other) {
    if (value == other) {
      return 0;
    }

    return value > other ? 1 : -1;
  }

  IntValueObject operator +(covariant other) => IntValueObject(other.value + value);
  IntValueObject operator -(covariant other) => IntValueObject((value - other.value).toInt());
}

abstract class StringValueObject extends Comparable<String> {
  String value;
  StringValueObject(this.value);

  @override
  int compareTo(String other) {
    if (value == other) {
      return 0;
    }

    return value != other ? 1 : -1;
  }
}

abstract class IdValueObject extends StringValueObject {
  IdValueObject(String value) : super(value);
}