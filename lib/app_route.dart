import 'package:expense_tracking_app/pages/charts.dart';
import 'package:expense_tracking_app/pages/expenses.dart';
import 'package:flutter/material.dart';

class AppRoute extends StatefulWidget {
  const AppRoute({super.key});

  @override
  State<AppRoute> createState() => _AppRouteState();
}

class _AppRouteState extends State<AppRoute> {
  int _selectedIndex = 0;
  static final List<Widget> _navPages = [
    const ExpensesPage(),
    const ChartPage()
  ];

  static final List<String> _pageTitles = [
    "Expenses",
    "Charts"
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        centerTitle: true,
      ),
      body: Center(
        child: _navPages[_selectedIndex],
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(
              Icons.attach_money,
            ),
            label: "Expenses",
          ),
          BottomNavigationBarItem(
              icon: Icon(
                Icons.pie_chart,
              ),
              label: "Charts"
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Theme.of(context).colorScheme.primary.withAlpha(120),
        iconSize: 22,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
      ),
    );
  }
}
