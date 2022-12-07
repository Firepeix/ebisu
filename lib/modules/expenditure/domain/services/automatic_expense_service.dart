import 'dart:developer';

import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/notification/domain/notification_listener_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

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
    final result = _parserService.parse(event.packageName, event.message);

    return await result.willMatch(
      ok: (incomplete) async {
        return incomplete != null ? await _complete(incomplete) : Result.ok(null);
      },
      err: (error) async => Result.err(error),
    );
  }

  Future<Result<CreatesExpense, ResultError>> _complete(IncompleteNotificationExpense incomplete) async {
    final cards = await _cardService.getCards(display: false);

    final isCard = (CardModel? model) => model?.name.contains(incomplete.cardName);

    return cards.match(
      err: (error) => Result.err(error),
      ok: (cards) {
        final card = cards.cast<CardModel?>().firstWhere(
              (element) => isCard(element) ?? false,
              orElse: () => null,
            );

        if (card == null) {
          return Result.err(NotificationParserError.validCardNotFoundForExpense(incomplete.cardName));
        }

        return Result.ok(incomplete.complete(card));
      },
    );
  }
}
