import 'package:ebisu/expenditure/domain/expense_source.dart';
import 'package:ebisu/expenditure/enums/expense_source_type.dart';

class UserModel implements ExpenseSource {
  @override
  String id;

  @override
  String name;

  @override
  ExpenseSourceType type;

  UserModel(this.id, this.name, this.type);
}