import 'package:flutter/material.dart';
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

  double get totalMonthlyExpenses {
    final now = DateTime.now();
    final currentMonth = now.month;
    final currentYear = now.year;

    double total = 0;

    for (final expense in state) {
      if (expense is RecurringExpense) {
        if (_isRecurringExpenseInCurrentMonth(expense, currentMonth, currentYear)) {
          total += expense.amount * timesInCurrentMonth(expense, currentMonth, currentYear);
        }
      } else {
        if (expense.date.month == currentMonth && expense.date.year == currentYear) {
          total += expense.amount;
        }
      }
    }
    return total;
  }

  int timesInCurrentMonth(RecurringExpense expense, int currentMonth, int currentYear) {
    final DateTime startDate = expense.date;

    if (expense.recurringType == RecurringType.monthly) {
      return 1;
    } else if (expense.recurringType == RecurringType.weekly) {
      DateTime firstDayOfMonth = DateTime(currentYear, currentMonth, 1);
      DateTime lastDayOfMonth = DateTime(currentYear, currentMonth + 1, 0);

      int recurrenceCount = 0;
      DateTime paymentDate = startDate;

      while (paymentDate.isBefore(lastDayOfMonth.add(const Duration(days: 1)))) {
        if (paymentDate.isAfter(firstDayOfMonth.subtract(const Duration(days: 1)))) {
          recurrenceCount++;
        }
        paymentDate = paymentDate.add(const Duration(days: 7)); // Weekly recurrence
      }

      return recurrenceCount;
    } else if (expense.recurringType == RecurringType.daily) {
      return DateUtils.getDaysInMonth(currentYear, currentMonth) - startDate.day;
    }

    return 0; // Fallback for non-recurring or unsupported recurring types
  }

  bool _isRecurringExpenseInCurrentMonth(
      RecurringExpense expense, int currentMonth, int currentYear) {
    final DateTime startDate = expense.date;

    if (expense.recurringType == RecurringType.monthly) {
      return (startDate.year < currentYear || (startDate.year == currentYear && startDate.month <= currentMonth));
    } else if (expense.recurringType == RecurringType.weekly) {
      DateTime paymentDate = startDate;
      while (paymentDate.isBefore(DateTime(currentYear, currentMonth + 1, 1))) {
        if (paymentDate.month == currentMonth && paymentDate.year == currentYear) {
          return true;
        }
        paymentDate = paymentDate.add(const Duration(days: 7));
      }
    }

    return false;
  }
}

final expensesProvider =
    StateNotifierProvider.autoDispose<ExpensesNotifier, List<Expense>>((ref) {
  return ExpensesNotifier();
});
