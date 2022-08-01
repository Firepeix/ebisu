
import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/models/travel_day_model.dart';
import 'package:ebisu/domain/travel/models/travel_expense_model.dart';
import 'package:ebisu/ui_components/chronos/labels/money.dart';
import 'package:injectable/injectable.dart';

@singleton
class TravelMapper {
  TravelDayModel toTravelDayModel(TravelDay travelDay) {
    return TravelDayModel(travelDay.id, travelDay.date.toIso8601String(), travelDay.budget.value);
  }

  TravelDay toTravelDay(TravelDayModel model) {
    return TravelDay(DateTime.parse(model.date), new Money(model.budget));
  }

  TravelExpenseModel toTravelExpenseModel(TravelExpense expense) {
    return TravelExpenseModel(expense.id, expense.description, expense.amount.value, expense.travelDayId);
  }

  TravelExpense toTravelExpense(TravelExpenseModel model) {
    return TravelExpense(model.description, Money(model.amount), model.travelDayId);
  }
}