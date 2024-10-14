import 'dart:math';

import 'package:flutter/material.dart';

import 'package:expense_tracking_app/widgets/chart/chart_bar.dart';
import 'package:expense_tracking_app/models/expense.dart';

import 'money_row.dart';

class BudgetView extends StatelessWidget {
  const BudgetView(
      {super.key, required this.totalExpenses, required this.budget});

  final double totalExpenses;
  final double budget;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 8,
          ),
          width: double.infinity,
          height: 176,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            gradient: LinearGradient(
              colors: [
                Theme.of(context).colorScheme.primary.withOpacity(0.3),
                Theme.of(context).colorScheme.primary.withOpacity(0.0)
              ],
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
            ),
          ),
          child: Column(
            children: [
              const Text("Monthly", style: TextStyle(fontWeight: FontWeight.bold),),
              MoneyRow(
                textTitle: "Budget",
                value: "$budget",
                color: Colors.black,
              ),
              MoneyRow(
                textTitle: "Expenses",
                value: "-${totalExpenses.toStringAsFixed(2)}",
                color: Colors.red,
              ),
              const Divider(
                color: Colors.grey,
                thickness: 1,
                indent: 16,
                endIndent: 16,
              ),
              MoneyRow(
                textTitle: "",
                value: (budget - totalExpenses).toStringAsFixed(2),
                color: (budget - totalExpenses) < 0 ? Colors.red : Colors.green,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
