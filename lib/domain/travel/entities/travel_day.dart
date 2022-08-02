import 'dart:convert';

import 'package:crypto/crypto.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';

class TravelDay {
  late String id;
  final DateTime date;
  final Money budget;

  TravelDay(this.date, this.budget) {
    this.id = md5.convert(utf8.encode(date.toString())).toString();
  }

  String get title {
    return '${date.day} de $month de ${date.year}';
  }

  String format() {
    return '${date.day}/${date.month.toString().padLeft(2, "0")}/${date.year}';
  }

  String get month {
    return {
      1: "Janeiro",
      2: "Fevereiro",
      3: "Março",
      4: "Abril",
      5: "Maio",
      6: "Junho",
      7: "Julho",
      8: "Agosto",
      9: "Setembro",
      10: "Outubro",
      11: "Novembro",
      12: "Dezembro",
    }[date.month] ?? "";
  }
}