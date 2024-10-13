import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracking_app/models/expense.dart';

class ExpensesNotifier extends StateNotifier<List<Expense>> {
  ExpensesNotifier() : super(_initialExpenses);

  static final List<Expense> _initialExpenses = [
    Expense(
      title: "Flutter Course",
      amount: 19.99,
      date: DateTime.now(),
      category: Category.work,
    ),
    Expense(
      title: "Cinema",
      amount: 15.69,
      date: DateTime(2024, 10, 11),
      category: Category.leisure,
    ),
    RecurringExpense(
      title: "Groceries",
      amount: 45.30,
      date: DateTime(2024, 9, 2),
      category: Category.food,
      recurringType: RecurringType.weekly,
    ),
    RecurringExpense(
      title: "Netflix",
      amount: 20.00,
      date: DateTime(2024, 5, 12),
      category: Category.leisure,
      recurringType: RecurringType.monthly,
    ),
  ];

  void addExpense(Expense expense) {
    state = [...state, expense];
  }

  void removeExpense(Expense expense) {
    state = state.where((e) => e != expense).toList();
  }

  double get totalExpenses {
    double total = 0;
    for (final expense in _initialExpenses) {
      total += expense.amount;
    }
    return total;
  }
}

final expensesProvider =
    StateNotifierProvider.autoDispose<ExpensesNotifier, List<Expense>>((ref) {
  return ExpensesNotifier();
});
