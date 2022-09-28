
abstract class ConfigurationRepositoryInterface {
  Future<void> cleanCredentials();
  Future<String?> getSheetId();
  Future<void> saveSheetId(String sheetId);
}