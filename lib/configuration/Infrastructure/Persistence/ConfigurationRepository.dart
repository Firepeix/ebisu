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
  Future<void> saveSheetId(String sheetId) async{
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(GoogleSheetsRepository.SPREADSHEET_ID_KEY, sheetId);
  }
}