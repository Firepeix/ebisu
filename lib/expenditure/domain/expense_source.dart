import 'package:ebisu/expenditure/enums/expense_source_type.dart';

class ExpenseSource {
  String id;
  String name;
  ExpenseSourceType type;

  ExpenseSource(this.id, this.name, this.type);
}