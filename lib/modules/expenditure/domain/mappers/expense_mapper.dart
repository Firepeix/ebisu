import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseMapper {
  CardMapper _cardMapper;

  ExpenseMapper(this._cardMapper);

  ExpenseModel fromJson(Map<dynamic, dynamic> json) {
    return ExpenseModel(
      id: json["id"],
      name: json["name"],
      type: ExpenseType.UNKNOWN.from(json["type"]),
      amount: json["amount"],
      date: DateTime.parse(json["date"]),
      card: json["card"] == null ? null : _cardMapper.fromJson(json["card"]),
      source: json["source"] == null ? null : _mapSource(json["source"]),
      beneficiary: json["beneficiary"] == null ? null : _mapSource(json["beneficiary"]),
      installments: json["installments"] == null ? null : _mapInstallments(json["installments"]),
    );
  }

  List<ExpenseModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }

  ExpenseSource _mapSource(Map<dynamic, dynamic> json) {
    return ExpenseSource(json["id"], json["name"], ExpenseSourceType.UNKNOWN.from(json["type"]));
  }

  ExpenseInstallments _mapInstallments(Map<dynamic, dynamic> json) {
    return ExpenseInstallments(json["current"], json["total"]);
  }
}