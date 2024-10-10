import 'package:expense_tracking_app/widgets/chart/chart.dart';
import 'package:expense_tracking_app/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracking_app/models/expense.dart';
import 'package:expense_tracking_app/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({super.key});

  @override
  State<ExpensesPage> createState() => _ExpensesPageState();
}

enum ViewOptions {all, oneTime, recurring}

class _ExpensesPageState extends State<ExpensesPage> {
  final List<Expense> _registeredExpenses = [
    Expense(
        title: "Flutter Course",
        amount: 19.99,
        date: DateTime.now(),
        category: Category.work,
        expenseType: ExpenseType.oneTime),
    Expense(
        title: "Cinema",
        amount: 15.69,
        date: DateTime.now(),
        category: Category.leisure,
        expenseType: ExpenseType.oneTime),
  ];

  late final List<Expense> _filteredExpenses;

  ViewOptions expensesView = ViewOptions.all;

  void showExpenses(Set<ViewOptions> newSelection) {
    if (newSelection == ViewOptions.all) {

    }
  }

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      useSafeArea: true,
      isScrollControlled: true,
      context: context,
      builder: (ctx) {
        return NewExpense(
          onAddExpense: _addExpense,
        );
      },
    );
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registeredExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final expenseIndex = _registeredExpenses.indexOf(expense);
    setState(() {
      _registeredExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        duration: const Duration(seconds: 3),
        content: const Text('Expense Deleted'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {
            setState(() {
              _registeredExpenses.insert(expenseIndex, expense);
            });
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget mainContent = const Center(
      child: Text('No Expenses found. Start adding some!'),
    );

    if (_registeredExpenses.isNotEmpty) {
      mainContent = ExpensesList(
        expenses: _registeredExpenses,
        onRemoveExpense: _removeExpense,
      );
    }

    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Column(
          children: [
            Chart(expenses: _registeredExpenses),
            SegmentedButton(
              segments: const [
                ButtonSegment(
                  value: ViewOptions.all,
                  label: Text('All'),
                ),
                ButtonSegment(
                  value: ViewOptions.recurring,
                  label: Text('Recurring'),
                ),
                ButtonSegment(
                  value: ViewOptions.oneTime,
                  label: Text('One-Time'),
                ),
              ],
              selected: <ViewOptions>{expensesView},
              onSelectionChanged: (Set<ViewOptions> newSelection) {
                setState(() {

                });
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
    );
  }
}
