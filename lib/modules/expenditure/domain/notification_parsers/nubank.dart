import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
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
  Result<IncompleteNotificationExpense, ResultError> parse(String message) {
  
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

    return Result.ok(IncompleteNotificationExpense(
        name: name.replaceAll("em ", ""),
        amount: parsedAmount,
        date: Moment.now(),
        cardName: "Nubank"
    ));
  }
}
