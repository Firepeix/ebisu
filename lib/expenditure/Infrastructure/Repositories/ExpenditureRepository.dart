import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';

class ExpenditureRepository implements ExpenditureRepositoryInterface {
  
  @override
  Map<int, String> getExpenditureTypes() {
    return Map.fromIterable(ExpenditureType.values, key: (e) => e.index, value: (e) => e.toString().split('.').elementAt(1));
  }
}