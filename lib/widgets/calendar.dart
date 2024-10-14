import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:expense_tracking_app/models/expense.dart';
import 'package:expense_tracking_app/providers/expenses_provider.dart';

class Calendar extends StatefulWidget {
  const Calendar({
    super.key,
    required this.allExpenses,
  });

  final List<Expense> allExpenses;

  @override
  State<Calendar> createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  DateTime _focusedDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();

  List<Expense> _getExpensesForDay(DateTime day, List<Expense> allExpenses) {
    List<Expense> expensesForDay = [];

    for (final expense in allExpenses) {
      if (expense is RecurringExpense) {
        if (_isRecurringExpenseOnDay(expense, day)) {
          expensesForDay.add(expense);
        }
      } else {
        if (expense.date.year == day.year &&
            expense.date.month == day.month &&
            expense.date.day == day.day) {
          expensesForDay.add(expense);
        }
      }
    }

    return expensesForDay;
  }

  bool _isRecurringExpenseOnDay(RecurringExpense expense, DateTime day) {
    if (expense.recurringType == RecurringType.monthly) {
      return (expense.date.day == day.day &&
          expense.date.month <= day.month &&
          expense.date.year <= day.year);
    } else if (expense.recurringType == RecurringType.weekly) {
      final difference = day.difference(expense.date).inDays;
      return (difference % 7 == 0) && day.isAfter(expense.date);
    } else if (expense.recurringType == RecurringType.daily) {
      return day.isAfter(expense.date);
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Monthly Calendar'),
        centerTitle: true,
      ),
      body: Column(
        children: [
          TableCalendar(
            firstDay: DateTime(_focusedDay.year, _focusedDay.month, 1),
            lastDay: DateTime(_focusedDay.year, _focusedDay.month + 1, 0),
            focusedDay: _focusedDay,
            selectedDayPredicate: (day) {
              return isSameDay(_selectedDay, day);
            },
            onDaySelected: (selectedDay, focusedDay) {
              setState(() {
                _selectedDay = selectedDay;
                _focusedDay = focusedDay;
              });
            },
            calendarStyle: CalendarStyle(
              todayDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primary,
                shape: BoxShape.circle,
              ),
              selectedDecoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                shape: BoxShape.circle,
              ),
            ),
            headerStyle: const HeaderStyle(
              formatButtonVisible: false,
              titleCentered: true,
            ),
            calendarBuilders: CalendarBuilders(
              markerBuilder: (context, day, events) {
                final expensesForDay = _getExpensesForDay(day, widget.allExpenses);
                if (expensesForDay.isNotEmpty) {
                  return Positioned(
                    bottom: 5,
                    child: Container(
                      width: 20,
                      height: 20,
                      decoration: const BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          expensesForDay.length.toString(),
                          style: const TextStyle(
                              color: Colors.white, fontSize: 12),
                        ),
                      ),
                    ),
                  );
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: _buildExpensesForSelectedDay(widget.allExpenses),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesForSelectedDay(List<Expense> allExpenses) {
    final expensesForSelectedDay =
        _getExpensesForDay(_selectedDay, allExpenses);

    if (expensesForSelectedDay.isEmpty) {
      return const Center(child: Text('No expenses for this day.'));
    }

    return ListView.builder(
      itemCount: expensesForSelectedDay.length,
      itemBuilder: (context, index) {
        final expense = expensesForSelectedDay[index];
        return ListTile(
          title: Text(expense.title),
          subtitle: Text(
            'Amount: \$${expense.amount.toStringAsFixed(2)} - Category: ${expense.category.name}',
          ),
        );
      },
    );
  }
}
