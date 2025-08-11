import 'package:expense_tracker/models/expense.dart';
import 'package:expense_tracker/widgets/chart/chart.dart';
import 'package:expense_tracker/widgets/expenses_list/expenses_list.dart';
import 'package:expense_tracker/widgets/new_expense.dart';
import 'package:flutter/material.dart';

class Expenses extends StatefulWidget {
  const Expenses({super.key});

  @override
  State<StatefulWidget> createState() {
    return _ExpensesState();
  }
}

class _ExpensesState extends State<Expenses> {
  final List<Expense> _registerdExpenses = [
    Expense(
      title: 'Flutter Course', 
      amount: 99.99, 
      date: DateTime.now(),category: 
      Category.work
    ),
    Expense(
      title: 'Cinema', 
      amount: 15.79, 
      date: DateTime.now(),category: 
      Category.leisure
    ),
  ];

  void _openAddExpenseOverlay() {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context, 
      builder: (ctx) {
      return NewExpense(onAddExpense: _addExpense,);
      });
  }

  void _addExpense(Expense expense) {
    setState(() {
      _registerdExpenses.add(expense);
    });
  }

  void _removeExpense(Expense expense) {
    final removeIndex = _registerdExpenses.indexOf(expense);
    setState(() {
      _registerdExpenses.remove(expense);
    });
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Expense Deleted!!!'),
        duration: Duration(seconds: 3),
        action: SnackBarAction(
          label: 'Undo', 
          onPressed: (){
            setState(() {
              _registerdExpenses.insert(removeIndex, expense);
            });
          }
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget _mainContent = const Center(child: Text('No Expense found, Start adding some'));

    if (_registerdExpenses.isNotEmpty) {
      _mainContent = ExpensesList(
              expenses: _registerdExpenses, 
              onRemoveExpense: _removeExpense,
            );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Flutter Expense Tracker',
          //style: Theme.of(context).textTheme.bodyLarge,
        ),
        actions: [
          IconButton(
            onPressed: _openAddExpenseOverlay,
            icon: Icon(Icons.add),)
        ],
      ),
      body: Column(
        children: [
          Chart(expenses: _registerdExpenses),
          Expanded(child: _mainContent
          ),
        ],
      ),
    );
  }
}
