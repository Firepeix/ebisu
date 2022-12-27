import 'package:ebisu/modules/configuration/domain/services/cache_service.dart';
import 'package:ebisu/modules/establishment/domain/mappers/establishment_mapper.dart';
import 'package:ebisu/modules/establishment/models/establishment_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:injectable/injectable.dart';

abstract class EstablishmentRepositoryInterface {

  static const ESTABLISHMENT_CACHE_KEY = "ESTABLISHMENT_CACHE";

  Future<Result<List<EstablishmentModel>, ResultError>> getEstablishments();
}

class _Endpoint {
  static const EstablishmentsIndex = "establishments";
}

@Injectable(as: EstablishmentRepositoryInterface)
class EstablishmentRepository implements EstablishmentRepositoryInterface {

  final Caron _caron;
  final EstablishmentMapper _mapper;
    final CacheServiceInterface _cacheService;

  EstablishmentRepository(this._caron, this._mapper, this._cacheService);

  @override
  Future<Result<List<EstablishmentModel>, ResultError>> getEstablishments() async {
    final establishments = await _getEstablishmentsFromCache();
    if (establishments != null) {
      return Ok(establishments);
    }

    final result = await _caron.getList<EstablishmentModel>(_Endpoint.EstablishmentsIndex, _mapper.fromJson);

    result.willLet(ok: _saveEstablishmentsInCache);

    return result.map((value) => value.data).message("Não foi possível buscar estabelecimentos");
  }

  Future<List<EstablishmentModel>?> _getEstablishmentsFromCache() async {
    return await _cacheService.getItem(EstablishmentRepositoryInterface.ESTABLISHMENT_CACHE_KEY, _mapper.fromJsonList);
  }

  Future<void> _saveEstablishmentsInCache(ListResponse<EstablishmentModel> result) async {
    return await _cacheService.setItem(EstablishmentRepositoryInterface.ESTABLISHMENT_CACHE_KEY, result.map(_mapper.toJson).toJson());
  }
}