import 'package:expense_tracking_app/widgets/calendar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../providers/expenses_provider.dart';
import '../widgets/chart/chart.dart';

class ViewsPage extends ConsumerStatefulWidget {
  const ViewsPage({
    super.key,
    required this.selectedView,
  });

  final String selectedView;

  @override
  ConsumerState<ViewsPage> createState() => _ViewsPageState();
}

class _ViewsPageState extends ConsumerState<ViewsPage> {
  @override
  Widget build(BuildContext context) {
    final allExpenses = ref.watch(expensesProvider);

    Widget activeWidget = Chart(expenses: allExpenses);

    if (widget.selectedView == 'calendar') {
      activeWidget = Calendar(allExpenses: allExpenses,);
    }



    return Center(
      child: activeWidget,
    );
  }
}
