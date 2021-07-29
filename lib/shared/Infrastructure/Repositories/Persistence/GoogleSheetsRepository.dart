import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GoogleSheetsRepository {
  static const CREDENTIALS_KEY = 'credentials-key';
  static const SPREADSHEET_ID_KEY = 'spread-sheet-id-key';
  final String debitSheetName = 'Atual - Debito';
  final String creditSheetName = 'Atual - Credito';

  static Future<String?> _getCredentials () async {
    final prefs = await SharedPreferences.getInstance();
    return Future(() {
      return prefs.getString(CREDENTIALS_KEY);
    });
  }

  Future<String?> getSheetId () async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(SPREADSHEET_ID_KEY);
  }

  Future<Worksheet> getSheet(String sheetName) async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheetId = await getSheetId();
    if(spreadSheetId != null) {
      final spreadSheet = await googleSheets.spreadsheet(spreadSheetId);
      return Future(() {
        final sheet = spreadSheet.worksheetByTitle(sheetName);
        if (sheet != null) {
          return sheet;
        }
        throw Error.safeToString('Planilha não encontrada');
      });
    }
    throw Error.safeToString('Por favor preencha o id da planilha nas opções!');
  }

  static Future<bool> isSetup() async {
    final credentials = await _getCredentials();
    return Future(() {
      return credentials != null ? true : false;
    });
  }
}