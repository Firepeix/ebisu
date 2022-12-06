import 'dart:developer';

import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';
import 'package:notifications/notifications.dart';

abstract class AutomaticExpenseService {
  Future<Result<CreatesExpense?, ResultError>> createOnNotification(NotificationEvent event);
}

@Injectable(as: AutomaticExpenseService)
class AutomaticExpenseServiceImpl implements AutomaticExpenseService {
  final ExpenseNotificationParserService _parserService;
  final CardServiceInterface _cardService;

  AutomaticExpenseServiceImpl(this._parserService, this._cardService);

  @override
  Future<Result<CreatesExpense?, ResultError>> createOnNotification(NotificationEvent event) async {
    final cards = await _cardService.getCards(display: false);
    if (cards.hasError()) {
      return Result(cards.getValue());
    }

    return _parserService.parse(event.packageName ?? "", event.message ?? "", cards.unwrap());
  }
}
