import 'package:ebisu/card/Domain/Card.dart';
import 'package:ebisu/configuration/Domain/Repositories/ConfigurationRepositoryInterface.dart';
import 'package:ebisu/shared/Infrastructure/Repositories/Persistence/GoogleSheetsRepository.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

@Singleton(as: ConfigurationRepositoryInterface)
class ConfigurationRepository extends GoogleSheetsRepository implements ConfigurationRepositoryInterface {
  static const CARD_TYPES_CACHE = 'card-types-cache';

  @override
  Future<void> cleanCredentials () async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(GoogleSheetsRepository.CREDENTIALS_KEY);
  }

  @override
  Future<void> cleanCardTypeCache() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove(CARD_TYPES_CACHE);
  }

  @override
  Future<void> saveSheetId(String sheetId) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(GoogleSheetsRepository.SPREADSHEET_ID_KEY, sheetId);
  }

  @override
  Future<void> saveActiveSheetName(String sheetName, CardClass type) async{
    final prefs = await SharedPreferences.getInstance();
    final sheetsNames = prefs.getStringList(GoogleSheetsRepository.ACTIVE_SHEET_CACHE) ?? List.generate(3, (index) => '');
    sheetsNames[type.index] = sheetName;
    prefs.setStringList(GoogleSheetsRepository.ACTIVE_SHEET_CACHE, sheetsNames);
  }

  @override
  Future<String> ebisuUrl() {
    return Future.value("http://localhost:3001");
  }
}