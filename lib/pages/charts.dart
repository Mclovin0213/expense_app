import 'package:flutter/material.dart';

import 'package:expense_tracking_app/models/expense.dart';
import 'package:expense_tracking_app/providers/expenses_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ChartsPage extends ConsumerWidget {
  const ChartsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final expenses = ref.watch(expensesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Expense Charts'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              const Text(
                'Expenses by Category (Pie Chart)',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              // const SizedBox(height: 16),
              _buildPieChart(expenses),
              // const SizedBox(height: 32),
              // const Text(
              //   'Expenses by Day (Bar Chart)',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 16),
              // _buildBarChart(expenses),
              // const SizedBox(height: 32),
              // const Text(
              //   'Cumulative Expenses Over Time (Line Chart)',
              //   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              // ),
              // const SizedBox(height: 16),
              // _buildLineChart(expenses),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPieChart(List<Expense> expenses) {
    final categoryTotals = <Category, double>{};

    for (var expense in expenses) {
      categoryTotals[expense.category] =
          (categoryTotals[expense.category] ?? 0) + expense.amount;
    }

    final pieChartSections = categoryTotals.entries.map((entry) {
      final category = entry.key;
      final total = entry.value;

      return PieChartSectionData(
        value: total,
        title: '${category.name}: ${total.toStringAsFixed(2)}',
        color: _getCategoryColor(category),
        radius: 100,
      );
    }).toList();

    return PieChart(
      PieChartData(
        sections: pieChartSections,
        centerSpaceRadius: 50,
        sectionsSpace: 2,
      ),
    );
  }

  Widget _buildBarChart(List<Expense> expenses) {
    final expensesByDay = <DateTime, double>{};

    for (var expense in expenses) {
      final day =
          DateTime(expense.date.year, expense.date.month, expense.date.day);
      expensesByDay[day] = (expensesByDay[day] ?? 0) + expense.amount;
    }

    final sortedDates = expensesByDay.keys.toList()..sort();

    final barGroups = sortedDates.map((date) {
      final totalForDay = expensesByDay[date]!;
      return BarChartGroupData(
        x: date.day,
        barRods: [
          BarChartRodData(
            toY: totalForDay,
            width: 15,
            color: Colors.blue,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      );
    }).toList();

    return BarChart(
      BarChartData(
        barGroups: barGroups,
        titlesData: FlTitlesData(
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: true),
          ),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  'Day ${value.toInt()}',
                  style: const TextStyle(color: Colors.black, fontSize: 10),
                );
              },
              reservedSize: 40,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLineChart(List<Expense> expenses) {
    final sortedExpenses = expenses..sort((a, b) => a.date.compareTo(b.date));
    double cumulativeTotal = 0;

    final spots = sortedExpenses.map((expense) {
      cumulativeTotal += expense.amount;
      return FlSpot(
          expense.date.millisecondsSinceEpoch.toDouble(), cumulativeTotal);
    }).toList();

    return LineChart(
      LineChartData(
        lineBarsData: [
          LineChartBarData(
            spots: spots,
            isCurved: true,
            barWidth: 3,
            color: Colors.green,
            dotData: FlDotData(show: false),
          ),
        ],
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: true)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (double value, meta) {
                final date = DateTime.fromMillisecondsSinceEpoch(value.toInt());
                return Text('${date.day}/${date.month}');
              },
            ),
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(Category category) {
    switch (category) {
      case Category.work:
        return Colors.blue;
      case Category.leisure:
        return Colors.red;
      case Category.food:
        return Colors.green;
      case Category.travel:
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }
}
