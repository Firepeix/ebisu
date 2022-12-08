import 'package:ebisu/modules/card/domain/services/card_service.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/configuration/domain/repositories/config_repository.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_notification_parser_service.dart';
import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:ebisu/modules/notification/domain/notification_listener_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:injectable/injectable.dart';

typedef Expense = IncompleteNotificationExpense;

class AutomaticExpenseError extends ResultError {
  const AutomaticExpenseError.alreadyExists() : super("Despesa ja cadastrada", "AEE1", null);
}

abstract class AutomaticExpenseService {
  Future<Result<CreatesExpense?, ResultError>> createOnNotification(NotificationEvent event);
}

@Injectable(as: AutomaticExpenseService)
class AutomaticExpenseServiceImpl implements AutomaticExpenseService {
  final ExpenseNotificationParserService _parserService;
  final CardServiceInterface _cardService;
  final ConfigRepositoryInterface _configRepository;

  AutomaticExpenseServiceImpl(this._parserService, this._cardService, this._configRepository);

  @override
  Future<Result<CreatesExpense?, ResultError>> createOnNotification(NotificationEvent event) async {
    final result = _parserService.parse(event.packageName, event.message);

    return await result.willThen((incomplete) async {
      if (incomplete == null) {
        return Ok(null);
      }

      return (await _validate(incomplete)).willThen((value) async => await _complete(value));
    });
  }

  Future<Result<IncompleteNotificationExpense, ResultError>> _validate(Expense expense) async {
    final String? encondedExpense = await _configRepository.getConfig("LAST_EXPENSE");
    final goodAction = () async {
      final ttl = Moment.now().add(Duration(seconds: 10)).toLocalDateTimeString();
      await _configRepository.setConfig("LAST_EXPENSE", "${expense.encode()}.$ttl");
      return Ok(expense);
    };

    if (encondedExpense == null) {
      return await goodAction();
    }

    final decodedExpense = encondedExpense.split(".");

    if (Moment.parse(decodedExpense.last).isPast()) {
      return await goodAction();
    }

    if (expense.isSameAsEncondedExpense(decodedExpense.sublist(0, decodedExpense.length - 1))) {
      return Err(AutomaticExpenseError.alreadyExists());
    }

    return await goodAction();
  }

  Future<Result<CreatesExpense, ResultError>> _complete(IncompleteNotificationExpense incomplete) async {
    final cards = await _cardService.getCards(display: false);

    final isCard = (CardModel? model) => model?.name == incomplete.cardName;

    return cards.match(
      err: (error) => Err(error),
      ok: (cards) {
        final card = cards.cast<CardModel?>().firstWhere(
              (element) => isCard(element),
              orElse: () => null,
            );

        if (card == null) {
          return Err(NotificationParserError.validCardNotFoundForExpense(incomplete.cardName));
        }

        return Ok(incomplete.complete(card));
      },
    );
  }
}
