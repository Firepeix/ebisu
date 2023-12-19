import 'package:ebisu/modules/common/core/domain/source.dart';
import 'package:ebisu/modules/expenditure/domain/services/expense_service.dart';
import 'package:ebisu/modules/expenditure/enums/expense_source_type.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/utils/result.dart';
import 'package:injectable/injectable.dart';

@injectable
class GetSourcesUseCase {
  final ExpenseServiceInterface _service;

  GetSourcesUseCase(this._service);

  Future<AnyResult<List<Source>>> getSources() async {
    final sources = await runCatching(() async => await _service.getSources());

    return sources.map((it) {
      return it.map((e) => Source(id: e.id, name: e.name, type: e.type == ExpenseSourceType.USER ? SourceType.USER : SourceType.ESTABLISHMENT))
          .toList();
    });
  }
}