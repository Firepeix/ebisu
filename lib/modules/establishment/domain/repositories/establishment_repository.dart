import 'package:ebisu/modules/establishment/domain/mappers/establishment_mapper.dart';
import 'package:ebisu/modules/establishment/models/establishment_model.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/http/client.dart';
import 'package:injectable/injectable.dart';

class EstablishmentError extends ResultError {
  const EstablishmentError.getEstablishments() : super("Não foi possível buscar cartões", "ES1", null);
}

abstract class EstablishmentRepositoryInterface {
  Future<Result<List<EstablishmentModel>, EstablishmentError>> getEstablishments();
}

class _Endpoint {
  static const EstablishmentsIndex = "establishments";
}

@Injectable(as: EstablishmentRepositoryInterface)
class EstablishmentRepository implements EstablishmentRepositoryInterface {
  final Caron _caron;
  final EstablishmentMapper _mapper;
  EstablishmentRepository(this._caron, this._mapper);

  @override
  Future<Result<List<EstablishmentModel>, EstablishmentError>> getEstablishments() async {
    final result = await _caron.getList<EstablishmentModel>(_Endpoint.EstablishmentsIndex, _mapper.fromJson);
    return result.map((value) => value.data).subError(EstablishmentError.getEstablishments());
  }
}