
abstract class ConfigurationRepositoryInterface {
  Future<void> cleanCardTypeCache();
  Future<void> cleanCredentials();
  Future<String?> getSheetId();
  Future<void> saveSheetId(String sheetId);
  Future<String> ebisuUrl();
}