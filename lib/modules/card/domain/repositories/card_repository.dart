import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

class CardError extends ResultError {
  CardError.getCards() : super("Não foi possível buscar cartões", "C1", null);
}

abstract class CardRepositoryInterface {
  Future<Result<List<CardModel>, CardError>> getCards();
}

class _Endpoint {
  static const CardsIndex = "cards";
}

@Injectable(as: CardRepositoryInterface)
class CardRepository implements CardRepositoryInterface {
  final Caron _caron;
  final CardMapper _mapper;
  CardRepository(this._caron, this._mapper);

  @override
  Future<Result<List<CardModel>, CardError>> getCards() async {
    final result = await _caron.get(_Endpoint.CardsIndex, _mapper.fromJsonList);
    return result.subError(CardError.getCards());
  }
}