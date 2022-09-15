import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

enum CardError implements ResultError {
  GET_CARDS_ERROR("Não foi possível buscar cartões", "C1");

  final String message;
  final String code;
  final dynamic details;

  const CardError(this.message, this.code, { this.details });
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
    return result.subError(CardError.GET_CARDS_ERROR);
  }
}