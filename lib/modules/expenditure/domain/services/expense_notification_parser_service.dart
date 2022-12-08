import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/expense_source.dart';
import 'package:ebisu/modules/expenditure/domain/notification_parsers/nubank.dart';
import 'package:ebisu/modules/expenditure/enums/expense_type.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:flutter/cupertino.dart';
import 'package:injectable/injectable.dart';

class NotificationParserError extends ResultError {
  NotificationParserError.nameNotFound(String message)
      : super("Não foi possivel encontrar um nome na mensagem", "ENP1", Details(data: message));
  NotificationParserError.amountNotFound(String message)
      : super("Não foi possivel encontrar um valor na mensagem", "ENP3", Details(data: message));
  NotificationParserError.validCardNotFoundForExpense(String cardName)
      : super("Não foi encontrado um cartão disponivel para a despesa", "ENP3", Details(data: cardName));
  NotificationParserError.couldNotParseAmount(String message)
      : super("Não foi possivel tranformar valor monetario", "ENP4", Details(data: message));
}

abstract class ExpenseNotificationParserService {
  Result<IncompleteNotificationExpense?, ResultError> parse(String id, String message);
}

abstract class NotificationExpenseParser {
  bool shouldParse(String parserId);
  Result<IncompleteNotificationExpense, ResultError> parse(String message);
}

@Injectable(as: ExpenseNotificationParserService)
class ExpenseNotificationParser implements ExpenseNotificationParserService {
  final _parsers = [NubankNotificationParser()];

  @override
  Result<IncompleteNotificationExpense?, ResultError> parse(String id, String message) {
    for (final parser in _parsers) {
      if (parser.shouldParse(id)) {
        return parser.parse(message);
      }
    }
    return Result.ok(null);
  }
}

@immutable
class IncompleteNotificationExpense {
  final String name;
  final String cardName;
  final int amount;
  final Moment date;

  IncompleteNotificationExpense(
      {required this.name, required this.amount, required this.date, required this.cardName});

  CreatesExpense complete(CardModel card) {
    return NotificationExpense(name: name, amount: amount, date: date, card: card);
  }

  bool isSameAsEncondedExpense(List<String> _encondedExpense) {
    return _encondedExpense.join(".") == encode();
  }

  String encode() {
    return [name, cardName, amount].join(".");
  }
}

@immutable
class NotificationExpense implements CreatesExpense {
  final String name;
  final int amount;
  final Moment date;
  final CardModel card;

  NotificationExpense({required this.name, required this.amount, required this.date, required this.card});

  String getName() => name;
  int getAmount() => amount;
  DateTime getDate() => date.toDateTime();
  ExpenseType getType() => ExpenseType.CREDIT;
  ExpenseSourceModel? getBeneficiary() => null;
  ExpenseSourceModel? getSource() => null;
  CardModel? getCard() => card;
  int? getCurrentInstallment() => null;
  int? getTotalInstallments() => null;
}
