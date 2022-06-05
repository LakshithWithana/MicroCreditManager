import 'package:flutter/material.dart';

class SingleExpenseModel extends ChangeNotifier {
  double totalExpenses = 0.0;

  void changeSum(double singleExpense) {
    totalExpenses = singleExpense;

    notifyListeners();
  }
}
