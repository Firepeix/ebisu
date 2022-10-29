import 'package:gsheets/gsheets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum AppendType {
  batch,
  single
}

@singleton
class GoogleSheetsRepository {
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

  Future<Worksheet> getSheet() async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheetId = await getSheetId();
    final sheetName = "TODO";
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

  Future<Worksheet> sheet(String title, { String? sheetId }) async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheetId = sheetId ?? await getSheetId();
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

  Future<void> append(List<dynamic> row, Worksheet sheet, {AppendType type = AppendType.single}) async {
    if (type == AppendType.single) {
      await sheet.values.appendRow(row);
      return;
    }
    await sheet.values.appendRows(row as List<List<dynamic>>);
  }
}