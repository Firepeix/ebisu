class Moment {
  final DateTime _value;

  Moment(this._value);

  String _enforceDoubleDigits(int number) => number >= 10 ? number.toString() : "0$number";

  String toString() {
    return "${_enforceDoubleDigits(_value.day)}/${_enforceDoubleDigits(_value.month)}/${_value.year}";
  }

  String toLocalDateTimeString() {
    final timestamp = _value.toIso8601String().split("T");
    final date = timestamp[0].split("/").reversed.join("-");
    return "$date ${timestamp[1].split(".")[0]}";
  }

  Moment add(Duration duration) {
    return Moment(_value.add(duration));
  }

  DateTime toDateTime() {
    return _value;
  }

  bool isPast() {
    return _value.isBefore(DateTime.now());
  }

  static Moment now() {
    return Moment(DateTime.now());
  }

  static Moment parse(String from) {
    final timestamp = from.split(" ");
    final date = timestamp[0].split("/").reversed.join("-");
    final format = "$date${timestamp.length > 1 ? " ${timestamp[1]}" : ""}";
    return Moment(DateTime.parse(format));
  }
}
