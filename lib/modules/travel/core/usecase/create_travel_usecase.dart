import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/gateway/travel_gateway.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';
import 'package:injectable/injectable.dart';

@injectable
class CreateTravelUseCase {
  final TravelGateway _gateway;

  CreateTravelUseCase(this._gateway);

  Future<AnyResult<void>> createDay(DateTime date, Money budget) async {
    return await _gateway.insert(TravelDay(date: Moment(date), budget: budget));
  }
}