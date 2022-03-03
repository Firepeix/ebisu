class Moment {
  final DateTime _value;

  Moment(this._value);

  String _enforceDoubleDigits(int number) => number >= 10 ? number.toString() : "0$number";

  String toString() {
    return "${_enforceDoubleDigits(_value.day)}/${_enforceDoubleDigits(_value.month)}/${_value.year}";
  }

  static Moment now () {
    return Moment(DateTime.now());
  }

  static Moment parse (String from) {
    final dates = from.split("/").reversed.join("-");
    return Moment(DateTime.parse(dates));
  }
}