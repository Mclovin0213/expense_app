import 'package:expense_tracking_app/pages/views.dart';
import 'package:expense_tracking_app/pages/expenses.dart';
import 'package:flutter/material.dart';

class AppRoute extends StatefulWidget {
  const AppRoute({super.key});

  @override
  State<AppRoute> createState() => _AppRouteState();
}

class _AppRouteState extends State<AppRoute> {
  int _selectedIndex = 0;
  double _budget = 1500;
  String _selectedView = 'chart';

  static final List<String> _viewOptions = ['chart', 'calendar'];

  static final List<String> _pageTitles = ["Expenses", "Views"];

  void _showSetBudgetDialog() {
    final TextEditingController budgetController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Set Budget'),
          content: TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(labelText: 'Enter your budget'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _budget = double.tryParse(budgetController.text) ?? 0.0;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _showChangeViewDialog() {
    showDialog(
      context: context,
      builder: (context) {
        String selectedValue = _selectedView;

        return AlertDialog(
          title: const Text('Change View'),
          content: DropdownButton(
            value: selectedValue,
            items: _viewOptions.map((String value) {
              return DropdownMenuItem(
                value: value,
                child: Text(value.toUpperCase()),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                selectedValue = newValue!;
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  _selectedView = selectedValue;
                });
                Navigator.of(context).pop();
              },
              child: const Text('Set'),
            ),
          ],
        );
      },
    );
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }



  @override
  Widget build(BuildContext context) {
    Widget? activePage;

    if (_selectedIndex == 0) {
      activePage = ExpensesPage(budget: _budget);
    } else {
      activePage = ViewsPage(selectedView: _selectedView,);
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_selectedIndex]),
        centerTitle: true,
        actions: [
          if (_selectedIndex == 0)
            TextButton(
              onPressed: _showSetBudgetDialog,
              child: const Text('Set Budget', style: TextStyle(color: Colors.white)),
            )
          else
            TextButton(
              onPressed: _showChangeViewDialog,
              child: const Text('Change View', style: TextStyle(color: Colors.white)),
            ),
        ],
      ),
      body: Center(
        child: activePage,
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
                Icons.view_column_outlined,
              ),
              label: "Views"),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor:
            Theme.of(context).colorScheme.primary.withAlpha(120),
        iconSize: 22,
        selectedFontSize: 12,
        unselectedFontSize: 12,
        onTap: _onItemTapped,
      ),
    );
  }
}
