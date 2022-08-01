import 'package:ebisu/domain/travel/entities/travel_day.dart';
import 'package:ebisu/domain/travel/entities/travel_expense.dart';
import 'package:ebisu/domain/travel/models/travel_day_model.dart';
import 'package:ebisu/domain/travel/models/travel_expense_model.dart';
import 'package:ebisu/domain/travel/travel_mapper.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';

abstract class TravelExpenseRepositoryInterface {
  Future<void> insert(TravelDay travelDay);
  Future<List<TravelDay>> getDays();
  Future<void> removeDay(TravelDay day);
  Future<void> saveSheet(TravelDay day);

  Future<void> insertExpense(TravelExpense expense);
  Future<List<TravelExpense>> getExpenses(TravelDay day);
  Future<void> removeExpense(TravelExpense expense);
}

@Injectable(as: TravelExpenseRepositoryInterface)
class TravelExpenseRepository implements TravelExpenseRepositoryInterface {
  static final config = AppConfiguration();

  static const DAY_BOX = 'travel_days';
  static const EXPENSE_BOX = 'travel_expenses';
  static const CREDENTIALS_KEY = 'credentials-key';
  static const SHEET = 'Gastos de viagem';

  final TravelMapper _mapper;
  final GoogleSheetsRepository _sheetRepository;

  TravelExpenseRepository(this._mapper, this._sheetRepository);


  Future<Box> _getBox<T>(String box) async {
    return await Hive.openBox<T>(box);
  }

  @override
  Future<void> insert(TravelDay travelDay) async {
    final box = await _getBox<TravelDayModel>(DAY_BOX);
    final model = _mapper.toTravelDayModel(travelDay);
    if (box.get(model.id) == null) {
      await box.put(model.id, model);
    }
  }

  @override
  Future<List<TravelDay>> getDays() async {
    final box = await _getBox<TravelDayModel>(DAY_BOX);
    return box.values.map((e) => _mapper.toTravelDay(e)).toList();
  }

  @override
  Future<void> insertExpense(TravelExpense expense) async {
    final box = await _getBox<TravelExpenseModel>(EXPENSE_BOX);
    final model = _mapper.toTravelExpenseModel(expense);
    if (box.get(model.id) == null) {
      await box.put(model.id, model);
    }
  }

  @override
  Future<List<TravelExpense>> getExpenses(TravelDay day) async  {
    final box = await _getBox<TravelExpenseModel>(EXPENSE_BOX);
    return box.values
        .map((e) => _mapper.toTravelExpense(e))
        .where((element) => element.travelDayId == day.id)
        .toList();
  }

  @override
  Future<void> removeDay(TravelDay day) async {
    final box = await _getBox<TravelDayModel>(DAY_BOX);
    await _removeExpensesFromDay(day);
    await box.delete(day.id);
  }

  @override
  Future<void> removeExpense(TravelExpense expense) async {
    final box = await _getBox<TravelExpenseModel>(EXPENSE_BOX);
    await box.delete(expense.id);
  }

  Future<void> _removeExpensesFromDay(TravelDay day) async {
    final box = await _getBox<TravelExpenseModel>(EXPENSE_BOX);
    final expenses =  box.values.where((element) => element.travelDayId == day.id).map((e) => e.id);
    await box.deleteAll(expenses);
  }

  @override
  Future<void> saveSheet(TravelDay day) async {
    final sheet = await _sheetRepository.sheet(SHEET, sheetId: config.travelSheetId);
    final expenses = await getExpenses(day);
    final mapToRow = (TravelExpense expense) => [day.format(), expense.description, expense.amount.toDouble(), config.user.name];
    await _sheetRepository.append(expenses.map(mapToRow).toList(), sheet, type: AppendType.batch);
  }
}