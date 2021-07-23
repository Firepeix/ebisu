abstract class IntValueObject extends Comparable<int> {
  int value;
  IntValueObject(this.value);

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