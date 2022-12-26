import 'package:ebisu/modules/card/domain/repositories/card_repository.dart';
import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/services/notification_service.dart';
import 'package:injectable/injectable.dart';

abstract class CardServiceInterface {
  Future<Result<List<CardModel>, ResultError>> getCards({bool display = true});
  Future<Result<CardModel, ResultError>> getCard(String id);
  Future<Result<void, ResultError>> updateCard(String id, SaveCardModel model);
}

@Injectable(as: CardServiceInterface)
class CardService implements CardServiceInterface {
  final CardRepositoryInterface _repository;
  final NotificationService _notificationService;
  final ExceptionHandlerInterface _exceptionHandler;

  CardService(this._repository, this._exceptionHandler, this._notificationService);

  @override
  Future<Result<List<CardModel>, ResultError>> getCards({bool display = true}) async {
    final result = await _repository.getCards();

    if (display) {
      _exceptionHandler.expect(result);
    }

    return result;
  }

  @override
  Future<Result<CardModel, ResultError>> getCard(String id) async {
    final result = await _repository.getCard(id);
    _exceptionHandler.expect(result);
    return result;
  }

  @override
  Future<Result<void, ResultError>> updateCard(String id, SaveCardModel model) async {
    _notificationService.displayLoading();
    final result = await _repository.update(id, model);

    result.let(ok: (value) => _notificationService.displaySuccess(message: value.message));

    _exceptionHandler.expect(result);
    return result;
  }
}
