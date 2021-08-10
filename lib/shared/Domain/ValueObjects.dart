abstract class IntValueObject extends Comparable<int> {
  late int value;
  IntValueObject(this.value);

  IntValueObject.money(String value) {
    this.value = IntValueObject.moneyTransform()(value);
  }

  static Function moneyTransform () {
    return (String value) => (double.parse(value) * 100).toInt();
  }

  String get real {
    final amount = value / 100;
    return "R\$ ${amount.toStringAsFixed(2)}".replaceAll('.', ',');
  }


  @override
  int compareTo(int other) {
    if (value == other) {
      return 0;
    }

    return value > other ? 1 : -1;
  }

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