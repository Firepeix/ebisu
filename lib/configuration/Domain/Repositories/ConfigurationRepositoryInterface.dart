import 'package:ebisu/card/Domain/Card.dart';

abstract class ConfigurationRepositoryInterface {
  Future<void> cleanCardTypeCache();
  Future<void> cleanCredentials();
  Future<String?> getSheetId();
  Future<String?> getActiveSheetName(CardClass type);
  Future<void> saveActiveSheetName(String sheetName, CardClass type);
  Future<void> saveSheetId(String sheetId);
}