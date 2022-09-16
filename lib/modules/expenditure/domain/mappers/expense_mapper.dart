import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/expenditure/models/expense/expenditure_model.dart';
import 'package:injectable/injectable.dart';

@injectable
class ExpenseMapper {
  CardMapper _cardMapper;

  ExpenseMapper(this._cardMapper);

  ExpenseModel fromJson(Map<dynamic, dynamic> json) {
    return ExpenseModel(
      id: json["id"].toString(),
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

  Map<dynamic, dynamic> toJson(CreatesExpense createsExpense) {
    return {
      "name": createsExpense.getName(),
      "amount": createsExpense.getAmount(),
      "date": createsExpense.getDate().toString(),
      "type": createsExpense.getType().name,
      "beneficiary": createsExpense.getBeneficiary() != null ? expenseSourceToJson(createsExpense.getBeneficiary()!) : null,
      "source": createsExpense.getSource() != null ? expenseSourceToJson(createsExpense.getSource()!) : null,
      "card": createsExpense.getCard() != null ? _cardMapper.toCreateExpenseJson(createsExpense.getCard()!) : null,
      "installments": createsExpense.getCurrentInstallment() != null ? {
        "current": createsExpense.getCurrentInstallment(),
        "max": createsExpense.getTotalInstallments()
      } : null
    };
  }

  Map<dynamic, dynamic> expenseSourceToJson(ExpenseSourceModel expenseSourceModel) {
    return {"id": expenseSourceModel.id, "type": expenseSourceModel.type.name};
  }

  List<ExpenseModel> fromJsonList(Map<dynamic, dynamic> json) {
    return (json["data"] as List<dynamic>).map((e) => fromJson(e)).toList();
  }

  ExpenseSourceModel _mapSource(Map<dynamic, dynamic> json) {
    return ExpenseSourceModel(json["id"].toString(), json["name"], ExpenseSourceType.UNKNOWN.from(json["type"]));
  }

  ExpenseInstallments _mapInstallments(Map<dynamic, dynamic> json) {
    return ExpenseInstallments(json["current"], json["total"]);
  }
}