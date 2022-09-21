import 'package:ebisu/modules/card/domain/repositories/card_repository.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

abstract class CardServiceInterface {
  Future<List<CardModel>> getCards();
  Future<Result<CardModel, ResultError>> getCard(String id);

}

@Injectable(as: CardServiceInterface)
class CardService implements CardServiceInterface {
  final CardRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;

  CardService(this._repository, this._exceptionHandler);

  @override
  Future<List<CardModel>> getCards() async {
    final result = await _repository.getCards();
    return _exceptionHandler.expect(result) ?? [];
  }

  @override
  Future<Result<CardModel, ResultError>> getCard(String id) async {
    final result = await _repository.getCard(id);
    _exceptionHandler.expect(result);
    return result;
  }
}