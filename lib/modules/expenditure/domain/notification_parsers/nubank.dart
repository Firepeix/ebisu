import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

class NubankNotificationParser implements NotificationExpenseParser {
  static const NAME = "NUBANK_PARSER_CONFIG";
  
  final ParserConfiguration configuration;

  NubankNotificationParser(this.configuration);

  static ParserConfiguration getDefaultConfiguration() {
    return ParserConfiguration(r"com.android.shell", r"em.*$", r"R\$.*\d");
  }

  @override
  bool shouldParse(String parserId) {
    return configuration.packageMatcher.hasMatch(parserId);
  }

  @override
  Result<IncompleteNotificationExpense, ResultError> parse(String message) {
    final name = configuration.nameMatcher.firstMatch(message)?[0];

    if (name == null) {
      return Result.err(NotificationParserError.nameNotFound(message));
    }

    final amount = configuration.amountMatcher.firstMatch(message)?[0];

    if (amount == null) {
      return Result.err(NotificationParserError.amountNotFound(message));
    }

    final parsedAmount = Money.parse(amount.replaceAll(r"R$ ", ""));

    if (parsedAmount == null) {
      return Result.err(NotificationParserError.couldNotParseAmount(message));
    }

    return Result.ok(IncompleteNotificationExpense(
        name: name.replaceAll("em ", ""), amount: parsedAmount, date: Moment.now(), cardName: "Nubank"));
  }
}
