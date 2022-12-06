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
  NotificationParserError.nameNotFound(String message) : super("Não foi possivel encontrar um nome na mensagem", "ENP1", Details(data: message));
  NotificationParserError.amountNotFound(String message) : super("Não foi possivel encontrar um valor na mensagem", "ENP3", Details(data: message));
  NotificationParserError.validCardNotFoundForExpense(String cardName) : super("Não foi encontrado um cartão disponivel para a despesa", "ENP3", Details(data: cardName)) ;
  NotificationParserError.couldNotParseAmount(String message) : super("Não foi possivel tranformar valor monetario", "ENP4", Details(data: message));
}

abstract class ExpenseNotificationParserService {
  Result<CreatesExpense?, ResultError> parse(String id, String message, List<CardModel> cards);
}

abstract class NotificationExpenseParser {
  bool shouldParse(String parserId);
  Result<CreatesExpense, ResultError> parse(String message, List<CardModel> cards);
}

@Injectable(as: ExpenseNotificationParserService)
class ExpenseNotificationParser implements ExpenseNotificationParserService {
  final _parsers = [NubankNotificationParser()];

  @override
  Result<CreatesExpense?, ResultError> parse(String id, String message, List<CardModel> cards) {
    for (final parser in _parsers) {
      if (parser.shouldParse(id)) {
        return parser.parse(message, cards);
      }
    }
    return Result.ok(null);
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