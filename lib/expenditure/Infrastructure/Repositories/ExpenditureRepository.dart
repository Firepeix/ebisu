import 'package:ebisu/expenditure/Domain/Expenditure.dart';
import 'package:ebisu/expenditure/Domain/Repositories/ExpenditureRepositoryInterface.dart';
import 'package:shared_preferences/shared_preferences.dart';


class GoogleSheetExpenditureRepository implements ExpenditureRepositoryInterface{
  String _credentials = '';

  @override
  Future<void> insert(Expenditure expenditure) {
    return Future.delayed(Duration(milliseconds: 100));
  }

  Future<bool> isSetup() async {
    final prefs = await SharedPreferences.getInstance();
    return Future(() {
      return prefs.getString(ExpenditureRepositoryInterface.CREDENTIALS_KEY) != null ? true : false;
    });
  }
}