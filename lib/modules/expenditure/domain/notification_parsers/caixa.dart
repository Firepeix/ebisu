import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/utils/let.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

class CaixaNotificationParser implements NotificationExpenseParser {
  static const NAME = "CAIXA_PARSER_CONFIG";
  
  final ParserConfiguration configuration;

  CaixaNotificationParser(this.configuration);

  static ParserConfiguration getDefaultConfiguration() {
    return ParserConfiguration(r".*\.messag", r"Aprovada (.*) R\$", r"R\$ (\d*,\d*)");
  }

    @override
  bool shouldParse(String parserId) {
    return configuration.packageMatcher.hasMatch(parserId);
  }

  @override
  Result<IncompleteNotificationExpense, ResultError> parse(String message) {
    final name = Let.match(configuration.nameMatcher.firstMatch(message), 1);

    if (name == null) {
      return Result.err(NotificationParserError.nameNotFound(message));
    }

    final amount = Let.match(configuration.amountMatcher.firstMatch(message), 1);

    if (amount == null) {
      return Result.err(NotificationParserError.amountNotFound(message));
    }

    final parsedAmount = Money.parse(amount);

    if (parsedAmount == null) {
      return Result.err(NotificationParserError.couldNotParseAmount(message));
    }

    return Result.ok(IncompleteNotificationExpense(
        name: name, amount: (parsedAmount / 2).ceil(), date: Moment.now(), cardName: "Caixa"
    ));
  }
}
