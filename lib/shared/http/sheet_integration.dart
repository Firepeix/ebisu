import 'dart:convert';

import 'package:ebisu/shared/http/request.dart';
import 'package:ebisu/shared/http/response.dart';
import 'package:gsheets/gsheets.dart';
import 'package:injectable/injectable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

abstract class CommandCentralInterface {
  Future<Res> execute<Res extends CommandCentralResponse>(String name, CommandCentralRequest<Res> body);
}

@Injectable(as: CommandCentralInterface)
class SheetCommandCentral implements CommandCentralInterface {
  static const CREDENTIALS_KEY = 'credentials-key';
  static const SPREADSHEET_ID = '1qwM3tf9nK_pW4fKuW6mAQIsQr65cLYwWuPRIbXpq_uA';
  static const COMMAND_SHEET = 'Scout';

  @override
  Future<Res> execute<Res extends CommandCentralResponse>(String name, CommandCentralRequest<Res> body) async {
    final sheet = await getSheet();
    final requestId = Uuid().v4().toString();
    await _insert(requestId, name, body, sheet);
    final response = await _getResponse(requestId, sheet);
    return Future.value(body.createResponse(response));
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

  Future<CommandResponse> _getResponse<Req extends CommandCentralRequest, Res>(String requestId, Worksheet sheet) async {
    final response = await _checkForResponse(requestId, sheet);
    return CommandResponse(response.commandCode, response.response);
  }

  Future<BaseResponse> _checkForResponse<Req extends CommandCentralRequest, Res>(String requestId, Worksheet sheet) async {
    List<Cell>? foundResponse;
    final maxAttempts = 30;
    int attempts = 0;
    while(foundResponse == null && attempts < maxAttempts) {
      final rows = await sheet.cells.allRows(fromRow: 2, fromColumn: 1, length: 10);
      rows.forEach((row) {
        final rowRequestId = row[CENTRAL_COMMAND_INDEX.REQUEST_ID.index].value;
        final responseCode = row[CENTRAL_COMMAND_INDEX.RESPONSE_CODE.index].value;
        if(rowRequestId == requestId && responseCode != "100" && responseCode != "") {
          foundResponse = row;
        }
      });
      attempts++;
      await Future.delayed(const Duration(seconds: 1));
    }

    if(foundResponse != null) {
      final responseCode = foundResponse![CENTRAL_COMMAND_INDEX.RESPONSE_CODE.index].value;
      final responseBody = foundResponse![CENTRAL_COMMAND_INDEX.RESPONSE_BODY.index].value;
      return Future.value(BaseResponse(int.parse(responseCode), responseBody));
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

class BaseResponse {
  final int code;
  final String response;

  BaseResponse(this.code, this.response);

  CommandCentralCode get commandCode {
    return {
      100: CommandCentralCode.in_progress,
      200: CommandCentralCode.success,
      500: CommandCentralCode.error
    }[code] ?? CommandCentralCode.error;
  }
}