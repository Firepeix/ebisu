import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';

abstract class ReporterServiceInterface {
  void reportError(ResultError error);
}

@Injectable(as: ReporterServiceInterface)
class ReporterService implements ReporterServiceInterface {
  void reportError(ResultError error) {
    if (kDebugMode) {
      printError(error);
    }

    if(!kDebugMode && error.details?.data != null && error.details?.data is FlutterErrorDetails) {
      FirebaseCrashlytics.instance.recordFlutterFatalError(error.details!.data);
    }
  }

  void printError(ResultError error) {
    // ignore: avoid_print
    print('======== TUTU DEU BUG =====================================================');
    final message = "${error.message ?? ''}${error.message != null && error.details?.messageAddon != null ? " " : ''}${error.details?.messageAddon ?? ''}";
    // ignore: avoid_print
    print('O seguinte erro foi pego: ${error.runtimeType} - $message - ${error.code}');

    if(error.details?.data != null && error.details?.data is FlutterErrorDetails) {
      final details = error.details?.data as FlutterErrorDetails;

      // If available, give a reason to the exception.
      if (details.context != null) {
        // ignore: avoid_print
        print('The following exception was thrown ${details.context}:');
      }

      // Need to print the exception to explain why the exception was thrown.
      // ignore: avoid_print
      print(details.exceptionAsString());

      final information = details.informationCollector?.call() ?? [];

      // Print information provided by the Flutter framework about the exception.
      if (information.isNotEmpty) {
        // ignore: avoid_print
        print('\n$information');
      }

      // Not using Trace.format here to stick to the default stack trace format
      // that Flutter developers are used to seeing.
      // ignore: avoid_print
      if (details.stack != null) {
        // ignore: avoid_print
        print('\n${details.stack}');
      }
    }

    // ignore: avoid_print
    print('====================================================================================================');
  }
}