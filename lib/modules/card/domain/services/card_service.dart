import 'package:ebisu/modules/card/domain/repositories/card_repository.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:injectable/injectable.dart';

abstract class CardServiceInterface {
  Future<List<CardModel>> getCards();
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
}