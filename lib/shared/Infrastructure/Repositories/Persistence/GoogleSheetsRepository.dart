import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GoogleSheetsRepository {
  static const CREDENTIALS_KEY = 'credentials-key';
  final String _spreadSheet = '';
  final String debitSheetName = 'Atual - Debito';
  final String creditSheetName = 'Atual - Credito';

  static Future<String?> _getCredentials () async {
    final prefs = await SharedPreferences.getInstance();
    return Future(() {
      return prefs.getString(CREDENTIALS_KEY);
    });
  }

  Future<Worksheet> getSheet(String sheetName) async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheet = await googleSheets.spreadsheet(_spreadSheet);
    return Future(() {
      final sheet = spreadSheet.worksheetByTitle(sheetName);
      if (sheet != null) {
        return sheet;
      }
      throw Error.safeToString('Planilha não encontrada');
    });
  }

  static Future<bool> isSetup() async {
    final credentials = await _getCredentials();
    return Future(() {
      return credentials != null ? true : false;
    });
  }
}