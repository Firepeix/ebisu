import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/utils/let.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

class PicpayNotificationParser implements NotificationExpenseParser {
  static const NAME = "PICPAY_PARSER_CONFIG";

  final ParserConfiguration configuration;

  PicpayNotificationParser(this.configuration);

  static ParserConfiguration getDefaultConfiguration() {
    return ParserConfiguration(r".*picpay", r"em (.*) foi A", r"R\$ (\d*,\d*)", "");
  }

  @override
  bool shouldParse(String parserId, String _message) {
    return configuration.packageMatcher.hasMatch(parserId);
  }

  @override
  Result<IncompleteNotificationExpense, ResultError> parse(String message) {
    final name = Let.match(configuration.nameMatcher.firstMatch(message), 1);

    if (name == null) {
      return Err(NotificationParserError.nameNotFound(message));
    }

    final amount = Let.match(configuration.amountMatcher.firstMatch(message), 1);

    if (amount == null) {
      return Err(NotificationParserError.amountNotFound(message));
    }

    final parsedAmount = Money.parse(amount);

    if (parsedAmount == null) {
      return Err(NotificationParserError.couldNotParseAmount(message));
    }

    return Ok(IncompleteNotificationExpense(
        name: name, amount: parsedAmount, date: Moment.now(), cardName: "Picpay"));
  }
}
