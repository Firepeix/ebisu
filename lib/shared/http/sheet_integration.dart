import 'dart:convert';

import 'package:ebisu/shared/http/Response.dart';
import 'package:ebisu/shared/http/request.dart';
import 'package:gsheets/gsheets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class CommandCentralInterface {
  Future<CommandResponse<Res>> execute<Req extends CommandCentralRequest, Res>(String name, Req body);
}

@Injectable(as: CommandCentralInterface)
class SheetCommandCentral implements CommandCentralInterface {
  static const CREDENTIALS_KEY = 'credentials-key';
  static const SPREADSHEET_ID = '1qwM3tf9nK_pW4fKuW6mAQIsQr65cLYwWuPRIbXpq_uA';
  static const COMMAND_SHEET = 'Scout';

  @override
  Future<CommandResponse<Res>> execute<Req extends CommandCentralRequest, Res>(String name, Req body) async {
    final sheet = await getSheet();
    final requestId = Uuid().v4().toString();
    await _insert(requestId, name, body, sheet);
    return await _getResponse(requestId, sheet);
  }

  Future<void> _insert<Req extends CommandCentralRequest, Res>(String requestId, String name, Req body, Worksheet sheet) async {
    final createdAt = DateTime.now().toString();
    final serializedBody = jsonEncode(body.json());
    await sheet.values.appendRow([
      name,
      serializedBody,
      "",
      "",
      createdAt,
      requestId
    ]);

    return Future.value();
  }

  Future<CommandResponse<Res>> _getResponse<Req extends CommandCentralRequest, Res>(String requestId, Worksheet sheet) async {
    final rawResponse = await _checkForResponse(requestId, sheet);
    print(rawResponse);
    throw Error.safeToString('aaaaaaaaaaaaa');
  }

  Future<List<Cell>> _checkForResponse<Req extends CommandCentralRequest, Res>(String requestId, Worksheet sheet) async {
    List<Cell>? foundResponse;
    final maxAttempts = 10;
    int attempts = 0;
    while(foundResponse == null && attempts < maxAttempts) {
      final rows = await sheet.cells.allRows(fromRow: 2, fromColumn: 1, length: 10);
      rows.forEach((row) {
        final rowRequestId = row[CENTRAL_COMMAND_INDEX.REQUEST_ID.index].value;
        final responseCode = row[CENTRAL_COMMAND_INDEX.RESPONSE_BODY.index].value;
        if(rowRequestId == requestId && responseCode != "100" && responseCode != "") {
          foundResponse = row;
        }
      });
      attempts++;
      await Future.delayed(const Duration(milliseconds: 1000));
    }

    if(foundResponse != null) {
      return Future.value(foundResponse);
    }

    throw Error.safeToString('Timeout no comando: $requestId');
  }

  static Future<String?> _getCredentials () async {
    final prefs = await SharedPreferences.getInstance();
    return Future(() {
      return prefs.getString(CREDENTIALS_KEY);
    });
  }

  Future<Worksheet> getSheet() async {
    final credentials = await _getCredentials();
    final googleSheets = GSheets(credentials!);
    final spreadSheet = await googleSheets.spreadsheet(SPREADSHEET_ID);
    return Future(() {
      final sheet = spreadSheet.worksheetByTitle(COMMAND_SHEET);
      if (sheet != null) {
        return sheet;
      }
      throw Error.safeToString('Planilha não encontrada');
    });
  }
}

enum CENTRAL_COMMAND_INDEX {
  NAME,
  BODY,
  RESPONSE_CODE,
  RESPONSE_BODY,
  CREATED_AT,
  REQUEST_ID
}