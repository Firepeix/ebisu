
import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/shared/persistence/database.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

class TravelDay {
  final String id;
  final Moment date;
  final Money budget;

  TravelDay({String? id, required this.date, required this.budget}) : this.id = id ?? Database.instance.createId();

  String get title {
    return '';//'${date.day} de $month de ${date.year}';
  }

  String format() {
    return '';//'${date.day}/${date.month.toString().padLeft(2, "0")}/${date.year}';
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
    }[2] ?? "";
  }
}