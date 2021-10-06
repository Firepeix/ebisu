import 'package:ebisu/card/Domain/Card.dart';
import 'package:gsheets/gsheets.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class GoogleSheetsRepository {
  static const CREDENTIALS_KEY = 'credentials-key';
  static const SPREADSHEET_ID_KEY = 'spread-sheet-id-key';
  static const ACTIVE_SHEET_CACHE = 'active-sheet-cache';

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

  Future<String> getActiveSheetName(CardClass type) async {
    final prefs = await SharedPreferences.getInstance();
    final sheetsNames = prefs.getStringList(ACTIVE_SHEET_CACHE);
    return sheetsNames != null ? sheetsNames[type.index] : '';
  }

  Future<Worksheet> getSheet(CardClass type) async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheetId = await getSheetId();
    final sheetName = await getActiveSheetName(type);
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

  Future<Worksheet> sheet(String title) async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheetId = await getSheetId();
    if(spreadSheetId != null) {
      final spreadSheet = await googleSheets.spreadsheet(spreadSheetId);
      return Future(() {
        final sheet = spreadSheet.worksheetByTitle(title);
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