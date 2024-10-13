import 'package:expense_tracking_app/widgets/chart/chart.dart';
import 'package:expense_tracking_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracking_app/models/expense.dart';
import 'package:expense_tracking_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/expenses_provider.dart'; // Import provider

class ExpensesPage extends ConsumerStatefulWidget {
  const ExpensesPage({super.key});

  @override
  ConsumerState<ExpensesPage> createState() => _ExpensesPageState();
}

enum ViewOption { all, oneTime, recurring }

class _ExpensesPageState extends ConsumerState<ExpensesPage> {
  ViewOption expensesView = ViewOption.all;

  List<Expense> _filterExpenses(List<Expense> expenses, ViewOption viewOption) {
    switch (viewOption) {
      case ViewOption.recurring:
        return expenses.where((expense) => expense.expenseType == ExpenseType.recurring).toList();
      case ViewOption.oneTime:
        return expenses.where((expense) => expense.expenseType == ExpenseType.oneTime).toList();
      case ViewOption.all:
      default:
        return expenses;
    }
  }

  void showExpenses(ViewOption newSelection) {
    setState(() {
      expensesView = newSelection;
    });
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(
          onAddExpense: (expense) => ref.read(expensesProvider.notifier).addExpense(expense),
        );
      },
    );
  }

  void _removeExpense(Expense expense) {
    ref.read(expensesProvider.notifier).removeExpense(expense);

    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            ref.read(expensesProvider.notifier).addExpense(expense);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final registeredExpenses = ref.watch(expensesProvider);

    final filteredExpenses = _filterExpenses(registeredExpenses, expensesView);

    Widget mainContent = const Center(
      child: Text('No Expenses found.'),
    );

    if (filteredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: filteredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Tracker'),
      ),
      body: Stack(
        alignment: Alignment.bottomRight,
        children: [
          Column(
            children: [
              Chart(expenses: registeredExpenses),
              SegmentedButton(
                segments: const [
                  ButtonSegment(
                    value: ViewOption.all,
                    label: Text('All'),
                  ),
                  ButtonSegment(
                    value: ViewOption.recurring,
                    label: Text('Recurring'),
                  ),
                  ButtonSegment(
                    value: ViewOption.oneTime,
                    label: Text('One-Time'),
                  ),
                ],
                selected: <ViewOption>{expensesView},
                onSelectionChanged: (Set<ViewOption> newSelection) {
                  showExpenses(newSelection.first);
                },
              ),
              Expanded(child: mainContent),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(
              right: 8,
              bottom: 8,
            ),
            child: FloatingActionButton(
              onPressed: _openAddExpenseOverlay,
              child: const Icon(
                Icons.add,
                size: 30,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
