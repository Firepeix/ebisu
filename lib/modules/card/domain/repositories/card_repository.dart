import 'package:ebisu/modules/card/domain/mappers/card_mapper.dart';
import 'package:ebisu/modules/card/infrastructure/transfer_objects/SaveCardModel.dart';
import 'package:ebisu/modules/card/models/card.dart';
import 'package:ebisu/modules/configuration/domain/services/cache_service.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';

abstract class CardRepositoryInterface {
  Future<Result<List<CardModel>, ResultError>> getCards();
  Future<Result<CardModel, ResultError>> getCard(String id);
  Future<Result<Success, ResultError>> update(String id, SaveCardModel model);

  static const String CARD_CACHE_KEY = "CARD_CACHE";
}

class _Endpoint {
  static const CardsIndex = "cards";
  static const Card = "cards/:cardId";
}

@Injectable(as: CardRepositoryInterface)
class CardRepository implements CardRepositoryInterface {
  final Caron _caron;
  final CardMapper _mapper;
  final CacheServiceInterface _cacheService;

  CardRepository(this._caron, this._mapper, this._cacheService);

  @override
  Future<Result<List<CardModel>, ResultError>> getCards() async {
    final cachedCards = await _getCardsFromCache();
    if (cachedCards != null) {
      return Ok(cachedCards);
    }

    final result = await _caron.getList<CardModel>(_Endpoint.CardsIndex, _mapper.fromJson);

    result.willLet(ok: _saveCardsInCache);

    return result.map((value) => value.data).message("Não foi possível buscar cartões");
  }

  Future<List<CardModel>?> _getCardsFromCache() async {
    return await _cacheService.getItem(CardRepositoryInterface.CARD_CACHE_KEY, _mapper.fromJsonList);
  }

  Future<void> _saveCardsInCache(ListResponse<CardModel> cards) async {
    return await _cacheService.setItem(CardRepositoryInterface.CARD_CACHE_KEY, cards.map(_mapper.toMap).toJson());
  }

  @override
  Future<Result<CardModel, ResultError>> getCard(String id) async {
    final result =
        await _caron.getLegacy<CardModel>(_Endpoint.Card.replaceAll(":cardId", id), _mapper.fromJson);
    return result.map((value) => value.data);
  }

  @override
  Future<Result<Success, ResultError>> update(String id, SaveCardModel model) async {
    final endpoint = _Endpoint.Card.replaceAll(":cardId", id);
    final result = await _caron.putLegacy<Success, SaveCardModel>(endpoint, model, _mapper.toJson);
    await _cacheService.clearItem(id);
    return result;
  }
}
