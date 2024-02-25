import 'dart:convert';
import 'dart:io';

import 'package:ebisu/modules/travel/dataprovider/database/entity/travel_day_entity.dart';
import 'package:ebisu/modules/travel/dataprovider/database/entity/travel_expense_entity.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:ebisu/shared/configuration/app_configuration.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:hive/hive.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
@injectable
class TravelFileRepository {
  static final config = AppConfiguration();

  static const DAY_BOX = 'travel_days';
  static const EXPENSE_BOX = 'travel_expenses';
  static const CREDENTIALS_KEY = 'credentials-key';
  static const SHEET = 'Gastos de viagem';

  final GoogleSheetsRepository _sheetRepository;

  TravelFileRepository(this._sheetRepository);

  Future<AnyResult<File>> _getDayFile() async {
    try {
      final directory = await getTemporaryDirectory();
      return Ok(File("${directory.path}/ebisu_travel_day.json"));
    }catch (error) {
      return Err(UnknownException(error));
    }
  }


  Future<Box> _getBox<T>(String box) async {
    return await Hive.openBox<T>(box);
  }

  Future<AnyResult<bool>> insert(TravelDayEntity travelDay) async {
    final file = await _getDayFile();
    return file.willNext((it) async => await getDays(path: it)).willThen((days) async {
      days.add(travelDay);
      await file.getOrThrow().writeAsString(jsonEncode(days));
      return Ok(true);
    });
  }

  Future<AnyResult<List<TravelDayEntity>>> getDays({ File? path }) async {
    if(path != null) {
      final contents = await path.readAsString();
      return Ok(TravelDayEntity.fromJson(jsonDecode(contents)));
    }

    return _getDayFile().willThen((it) async {
      final contents = await it.readAsString();
      return Ok(TravelDayEntity.fromJson(jsonDecode(contents)));
    });
  }

  Future<void> insertExpense(TravelExpenseEntity expense) async {
    final box = await _getBox<TravelExpenseEntity>(EXPENSE_BOX);
    if (box.get(expense.id) == null) {
      await box.put(expense.id, expense);
    }
  }

  Future<List<TravelExpenseEntity>> getExpenses(TravelDayEntity day) async  {
    return [];/*final box = await _getBox<TravelDayEntity>(EXPENSE_BOX);

    return box.values
        .map((e) => _mapper.toTravelExpense(e))
        .where((element) => element.travelDayId == day.id)
        .toList();*/
  }

  Future<void> removeDay(TravelDayEntity day) async {
    final box = await _getBox<TravelDayEntity>(DAY_BOX);
    await _removeExpensesFromDay(day);
    await box.delete(day.id);
  }

  Future<void> removeExpense(TravelExpenseEntity expense) async {
    final box = await _getBox<TravelExpenseEntity>(EXPENSE_BOX);
    await box.delete(expense.id);
  }

  Future<void> _removeExpensesFromDay(TravelDayEntity day) async {
    final box = await _getBox<TravelDayEntity>(EXPENSE_BOX);
    final expenses =  box.values.where((element) => element.travelDayId == day.id).map((e) => e.id);
    await box.deleteAll(expenses);
  }

  Future<void> saveSheet(TravelDayEntity day) async {
    final sheet = await _sheetRepository.sheet(SHEET, sheetId: config.travelSheetId);
    final expenses = await getExpenses(day);
    final mapToRow = (TravelExpenseEntity expense) => [day.toString(), expense.description, expense.amount.toDouble(), config.user.name];
    await _sheetRepository.append(expenses.map(mapToRow).toList(), sheet, type: AppendType.batch);
  }
}