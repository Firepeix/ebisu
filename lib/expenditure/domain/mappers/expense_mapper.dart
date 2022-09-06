import 'package:ebisu/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/expenditure/models/expense/expenditure_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseMapper {
  CardMapper _cardMapper;

  ExpenseMapper(this._cardMapper);

  ExpenseModel fromJson(Map<dynamic, dynamic> json) {
    return ExpenseModel(
      this.id: json[""],
      this.name: json[""],
      this.type: json[""],
      this.amount: json[""],
      this.date: json[""],
      this.card: json[""],
      this.source: json[""],
      this.beneficiary: json[""],
      this.installments: json[""],
    );
  }

  List<ExpenseModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }
}