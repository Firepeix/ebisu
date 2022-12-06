import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

class NubankNotificationParser implements NotificationExpenseParser {
  static RegExp nameMatcher = RegExp(r"em.*$");
  static RegExp amountMatcher = RegExp(r"R\$.*\d");


  @override
  bool shouldParse(String parserId) {
    return parserId == "com.android.shell";
  }

  @override
  Result<CreatesExpense, ResultError> parse(String message, List<CardModel> cards) {
    final card = cards.cast<CardModel?>().firstWhere((element) => element?.name.contains("Nubank") ?? false, orElse: () => null,);
    
    if (card == null) {
      return Result.err(NotificationParserError.validCardNotFoundForExpense("Nubank"));
    } 

    final name = nameMatcher.firstMatch(message)?[0];

    if (name == null) {
      return Result.err(NotificationParserError.nameNotFound(message));
    }

    final amount = amountMatcher.firstMatch(message)?[0];
    
    if (amount == null) {
      return Result.err(NotificationParserError.amountNotFound(message));
    }

    final parsedAmount = Money.parse(amount.replaceAll(r"R$ ", ""));

    if (parsedAmount == null) {
      return Result.err(NotificationParserError.couldNotParseAmount(message));
    }

    final expense = NotificationExpense(
        name: name.replaceAll("em ", ""),
        amount: parsedAmount,
        date: Moment.now(),
        card: cards.firstWhere((element) => element.name.contains("Nubank")));

    return Result.ok(expense);
  }
}
