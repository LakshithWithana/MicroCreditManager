import 'package:flutter/material.dart';

class SingleCollectionModel extends ChangeNotifier {
  double totalProfit = 0.0;
  double totalCollection = 0.0;
  double totalExpenses = 0.0;

  void changeSum(double singleProfit, double singleCollection) {
    totalProfit = singleProfit;
    totalCollection = singleCollection;

    notifyListeners();
  }

  void changeExpensesSum(double singleExpense) {
    totalExpenses = singleExpense;

    notifyListeners();
  }
}
