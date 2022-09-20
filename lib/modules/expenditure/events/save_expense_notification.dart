import 'package:ebisu/modules/expenditure/infrastructure/transfer_objects/creates_expense.dart';
import 'package:flutter/material.dart';

class SaveExpenseNotification extends Notification {
  final CreatesExpense model;

  SaveExpenseNotification(this.model);
}