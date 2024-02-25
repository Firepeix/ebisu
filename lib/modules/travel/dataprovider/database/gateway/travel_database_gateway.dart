import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/modules/travel/core/gateway/travel_gateway.dart';
import 'package:ebisu/modules/travel/dataprovider/database/mapper/travel_mapper.dart';
import 'package:ebisu/modules/travel/dataprovider/database/repository/travel_file_repository.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:injectable/injectable.dart';

@Injectable(as: TravelGateway)
class TravelExpenseRepository implements TravelGateway {
  final TravelFileRepository _repository;

  TravelExpenseRepository(this._repository);

  @override
  Future<AnyResult<void>> insert(TravelDay travelDay) async {
    return await _repository.insert(travelDay.toTravelEntity());
  }

  @override
  Future<AnyResult<List<TravelDay>>> getDays() async {
    final days = await _repository.getDays();
    return days.map((e) => e.map((e) => e.toTravelDay()).toList());
  }

  @override
  Future<void> insertExpense(TravelExpense expense) async {
    return await _repository.insertExpense(expense.toTravelExpenseEntity());
  }

  @override
  Future<List<TravelExpense>> getExpenses(TravelDay day) async  {
    final days = await _repository.getExpenses(day.toTravelEntity());
    return days.map((e) => e.toTravelExpense()).toList();
  }

  @override
  Future<void> removeDay(TravelDay day) async {
    return await _repository.removeDay(day.toTravelEntity());
  }

  @override
  Future<void> removeExpense(TravelExpense expense) async {
    return await _repository.removeExpense(expense.toTravelExpenseEntity());
  }

  @override
  Future<void> saveSheet(TravelDay day) async {
    return await _repository.saveSheet(day.toTravelEntity());
  }
}