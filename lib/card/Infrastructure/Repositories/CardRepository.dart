import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/card/Domain/Repositories/CardRepositoryInterface.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GoogleSheetCardRepository extends GoogleSheetsRepository implements CardRepositoryInterface {
  static final GoogleSheetCardRepository _singleton = GoogleSheetCardRepository._internal();
  static const CARD_TYPES_CACHE = 'card-types-cache';

  factory GoogleSheetCardRepository() {
    return _singleton;
  }

  GoogleSheetCardRepository._internal();

  @override
  Future<Map<int, String>> getCardTypes() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? cardTypes = prefs.getStringList(CARD_TYPES_CACHE);
    if (cardTypes != null) {
      return Future(() => cardTypes!.asMap());
    }
    cardTypes = await _getCardTypesFromRepository();
    prefs.setStringList(CARD_TYPES_CACHE, cardTypes);
    return cardTypes.asMap();
  }


  Future<List<String>> _getCardTypesFromRepository() async {
    final sheet = await getSheet(creditSheetName);
    final cells = await sheet.cells.allRows(fromRow: 3, fromColumn: 1, length: CARD_COLUMNS.LABEL.index);
    return cells.toList().map((cell) => cell[0].value).toList();
  }

  @override
  getCardClass() {
    return CardClass;
  }

  @override
  Future<void> cleanCardTypeCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(CARD_TYPES_CACHE);
  }
}

enum CARD_COLUMNS {
  NOTHING,
  LABEL
}