import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';

class CardError extends ResultError {
  CardError.getCards() : super("Não foi possível buscar cartões", "C1", null);
}

abstract class CardRepositoryInterface {
  Future<Result<List<CardModel>, CardError>> getCards();
  Future<Result<CardModel, ResultError>> getCard(String id);
  Future<Result<Success, ResultError>> update(String id, SaveCardModel model);
}

class _Endpoint {
  static const CardsIndex = "cards";
  static const Card = "cards/:cardId";
}

@Injectable(as: CardRepositoryInterface)
class CardRepository implements CardRepositoryInterface {
  final Caron _caron;
  final CardMapper _mapper;
  CardRepository(this._caron, this._mapper);

  @override
  Future<Result<List<CardModel>, CardError>> getCards() async {
    final result = await _caron.getList<CardModel>(_Endpoint.CardsIndex, _mapper.fromJson);
    return result.map((value) => value.data).subError(CardError.getCards());
  }

  @override
  Future<Result<CardModel, ResultError>> getCard(String id) async {
    final result = await _caron.get<CardModel>(_Endpoint.Card.replaceAll(":cardId", id), _mapper.fromJson);
    return result.map((value) => value.data);
  }

  @override
  Future<Result<Success, ResultError>> update(String id, SaveCardModel model) async {
    final endpoint = _Endpoint.Card.replaceAll(":cardId", id);
    return await _caron.put<Success, SaveCardModel>(endpoint, model, _mapper.toJson);
  }
}