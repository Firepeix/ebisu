import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';

AnyResult<T> runCatchingSync<T>(T Function() block) {
  try {
    return Ok(block());
  } catch(error) {
    return Err(UnknownError(error));
  }
}

Future<AnyResult<T>> runCatching<T>(Future<T> Function() block) async {
  try {
    final result = await block();
    return Ok(result);
  } catch(error) {
    return Err(UnknownError(error));
  }
}