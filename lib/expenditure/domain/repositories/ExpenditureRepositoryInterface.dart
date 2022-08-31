import 'package:ebisu/expenditure/domain/Expenditure.dart';
import 'package:ebisu/expenditure/domain/ExpenditureSummary.dart';

abstract class ExpenditureRepositoryInterface {
  Future<void> insert(Expenditure expenditure);
  Future<List<Expenditure>> getExpenditures(bool cacheLess);
  Future<List<ExpenditureSummary>> getCreditExpenditureSummaries (bool cacheLess);
  Future<DebitExpenditureSummary> getDebitExpenditureSummary (bool cacheLess);
}