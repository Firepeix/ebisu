import 'package:ebisu/modules/establishment/domain/repositories/establishment_repository.dart';
import 'package:ebisu/modules/establishment/models/establishment_model.dart';
import 'package:ebisu/shared/exceptions/handler.dart';
import 'package:injectable/injectable.dart';

abstract class EstablishmentServiceInterface {
  Future<List<EstablishmentModel>> getEstablishments();
}

@Injectable(as: EstablishmentServiceInterface)
class EstablishmentService implements EstablishmentServiceInterface {
  final EstablishmentRepositoryInterface _repository;
  final ExceptionHandlerInterface _exceptionHandler;

  EstablishmentService(this._repository, this._exceptionHandler);

  @override
  Future<List<EstablishmentModel>> getEstablishments() async {
    final result = await _repository.getEstablishments();
    return _exceptionHandler.expect(result) ?? [];
  }
}