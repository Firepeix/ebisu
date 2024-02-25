import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/gateway/travel_gateway.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetTravelUseCase {
  final TravelGateway _gateway;

  GetTravelUseCase(this._gateway);

  Future<AnyResult<List<TravelDay>>> getDays() async {
    return await _gateway.getDays();
  }
}