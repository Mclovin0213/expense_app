import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:expense_tracking_app/models/expense.dart';

// Define a class to manage the state of the expense list
class ExpensesNotifier extends StateNotifier<List<Expense>> {
  ExpensesNotifier() : super(_initialExpenses);

  // Static initial list of expenses for better readability and performance
  static final List<Expense> _initialExpenses = [
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
    Expense(
        title: "Groceries",
        amount: 45.30,
        date: DateTime.now(),
        category: Category.food,
        expenseType: ExpenseType.recurring),
    Expense(
        title: "Bus Ticket",
        amount: 2.50,
        date: DateTime.now(),
        category: Category.work,
        expenseType: ExpenseType.oneTime),
    Expense(
        title: "Gym Membership",
        amount: 29.99,
        date: DateTime.now(),
        category: Category.leisure,
        expenseType: ExpenseType.recurring),
    Expense(
        title: "Coffee",
        amount: 4.20,
        date: DateTime.now(),
        category: Category.food,
        expenseType: ExpenseType.oneTime),
    Expense(
        title: "Electricity Bill",
        amount: 60.00,
        date: DateTime.now(),
        category: Category.work,
        expenseType: ExpenseType.recurring),
    Expense(
        title: "Movie Streaming Subscription",
        amount: 12.99,
        date: DateTime.now(),
        category: Category.leisure,
        expenseType: ExpenseType.recurring),
    Expense(
        title: "Book Purchase",
        amount: 22.50,
        date: DateTime.now(),
        category: Category.leisure,
        expenseType: ExpenseType.oneTime),
    Expense(
        title: "Concert Ticket",
        amount: 55.00,
        date: DateTime.now(),
        category: Category.leisure,
        expenseType: ExpenseType.oneTime),
    Expense(
        title: "Phone Bill",
        amount: 40.00,
        date: DateTime.now(),
        category: Category.work,
        expenseType: ExpenseType.recurring),
    Expense(
        title: "Lunch at Restaurant",
        amount: 18.75,
        date: DateTime.now(),
        category: Category.food,
        expenseType: ExpenseType.oneTime),
  ];

  // Function to add a new expense
  void addExpense(Expense expense) {
    state = [...state, expense]; // maintain immutability
  }

  // Function to remove an expense
  void removeExpense(Expense expense) {
    state = state.where((e) => e != expense).toList();
  }
}

// Define the provider for the list of expenses with autoDispose
final expensesProvider =
    StateNotifierProvider.autoDispose<ExpensesNotifier, List<Expense>>((ref) {
  return ExpensesNotifier();
});
