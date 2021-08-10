import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/ExpenditureSummary.dart';

abstract class ExpenditureRepositoryInterface {
  Future<void> insert(Expenditure expenditure);
  Future<List<Expenditure>> getExpenditures(bool cacheLess);
  Future<List<ExpenditureSummary>> getCreditExpenditureSummaries (bool cacheLess);
}