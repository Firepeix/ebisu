import 'package:ebisu/modules/common/core/domain/money.dart';
import 'package:ebisu/modules/travel/core/domain/travel_day.dart';
import 'package:ebisu/modules/travel/core/domain/travel_expense.dart';
import 'package:ebisu/modules/travel/dataprovider/database/entity/travel_day_entity.dart';
import 'package:ebisu/modules/travel/dataprovider/database/entity/travel_expense_entity.dart';
import 'package:ebisu/ui_components/chronos/time/moment.dart';

extension TravelDayEntityMapper on TravelDayEntity {
  TravelDay toTravelDay() => TravelDay(
    id: id,
    date: Moment.parse(date),
    budget: Money(budget)
  );
}

extension TravelDayMapper on TravelDay {
  TravelDayEntity toTravelEntity() => TravelDayEntity(
      id: id,
      date: date.toLocalDateTimeString(),
      budget: budget.value
  );
}

extension TravelExpenseEntityMapper on TravelExpenseEntity {
  TravelExpense toTravelExpense() => TravelExpense(
      description: description,
      travelDayId: travelDayId,
      amount: Money(amount)
  );
}

extension TravelExpenseMapper on TravelExpense {
  TravelExpenseEntity toTravelExpenseEntity() => TravelExpenseEntity(
      id: id,
      description: description,
      amount: amount.value,
      travelDayId: travelDayId
  );
}

