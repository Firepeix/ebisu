import 'package:ebisu/modules/expenditure/domain/repositories/purchase_repository.dart';
import 'package:ebisu/modules/purchases/debit/core/domain/debit_summary.dart';
import 'package:ebisu/shared/exceptions/result.dart';
import 'package:ebisu/shared/exceptions/result_error.dart';
import 'package:injectable/injectable.dart';

@injectable
class SummarizeDebitUseCase {

  PurchaseRepositoryInterface _repositoryInterface;

  SummarizeDebitUseCase(this._repositoryInterface);

  Future<Result<DebitSummary, ResultError>> getDebitSummary() async {
    return await _repositoryInterface.getDebitSummary();
  }

  Future<Result<DebitSummary, ResultError>> getFutureDebitSummary() async {
    return await _repositoryInterface.getFutureDebitSummary();
  }
}