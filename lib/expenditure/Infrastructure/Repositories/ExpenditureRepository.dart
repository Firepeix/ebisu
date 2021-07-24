import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';

class ExpenditureRepository {
  Map<int, String> getExpenditureTypes() {
    return Map.fromIterable(ExpenditureType.values, key: (e) => e.index, value: (e) => e.toString().split('.').elementAt(1));
  }
}

class GoogleSheetExpenditureRepository extends ExpenditureRepository implements ExpenditureRepositoryInterface{
  @override
  Future<void> insert(Expenditure expenditure) {
    return Future.delayed(Duration(milliseconds: 100));
  }

  bool isSetup() {
    return false;
  }
}