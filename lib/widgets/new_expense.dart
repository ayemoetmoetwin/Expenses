import 'dart:io';

import 'package:expense_tracker/models/expense.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class NewExpense extends StatefulWidget{
  const NewExpense({super.key, required this.onAddExpense});
  final void Function(Expense expense) onAddExpense;
  @override
  State<StatefulWidget> createState() {
    return _NewExpenseState();
  }

}

class _NewExpenseState extends State<NewExpense> {
  final _titleController = TextEditingController();
  final _amountController = TextEditingController();
  DateTime? _selectedDate;
  Category _selectedCategory = Category.leisure;

  void _presentDatePicker() async {
    final now = DateTime.now();
    final firstDate = DateTime(now.year - 1, now.month, now.day);
    var pickedDate = await showDatePicker(
      context: context, 
      initialDate: now,
      firstDate: firstDate, 
      lastDate: now,);
    
    setState(() {
      _selectedDate = pickedDate;
    });
  }

  void _showDialog() {
    if (Platform.isIOS) {
      showCupertinoDialog(context: context, builder: (ctx) => CupertinoAlertDialog(
          title: Text('Invalid Input'),
            content: Text('Please make sure a valid title, amount,date and category was entered.'),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                }, child: const Text('Okay')),
            ],
        ));
    } else {
      showDialog(
        context: context, 
        builder: (ctx) => AlertDialog(
          title: Text('Invalid Input'),
          icon: Icon(Icons.info_rounded,color: Colors.red,),
          content: Text('Please make sure a valid title, amount,date and category was entered.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              }, child: const Text('Okay')),
          ],
        ));
    }
  }

  void _summitExpenseData() {
    final enterAmount = double.tryParse(_amountController.text);
    final amountIsValid = enterAmount == null || enterAmount <= 0;
    if (_titleController.text.trim().isEmpty || amountIsValid || _selectedDate == null) {
      _showDialog();
        return;
    }

    widget.onAddExpense(
      Expense(
        title: _titleController.text, 
        amount: enterAmount, 
        date: _selectedDate!, 
        category: _selectedCategory
      ));
      Navigator.pop(context);
  }
  
  @override
  void dispose() {
    _titleController.dispose();
    _amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final keyboardSpace = MediaQuery.of(context).viewInsets.bottom;
    return LayoutBuilder(builder: (ctx, constraints) {
      var width = constraints.maxWidth;
      
      var children = [
              if (width >= 600) 
                Row(children: [
                Expanded(
                  child: 
                    _buildTitleTextField(
                      controller: _titleController,
                      label: 'Title',
                      keyboardType: TextInputType.text,
                      isAmount: false
                    )
                ),
              const SizedBox(width: 10,),
              Expanded(
                  child: 
                    _buildTitleTextField(
                      controller: _amountController,
                      label: 'Amount',
                      keyboardType: TextInputType.number,
                      isAmount: true
                    ),
                  ),
                ],)
              else 
                _buildTitleTextField(
                  controller: _titleController,
                  label: 'Title',
                  keyboardType: TextInputType.text,
                  isAmount: false
                ),
              if (width >= 600)
              Row(children: [
                    _buildCategoryDropdown(
                      selectedValue: _selectedCategory,
                      onChanged: (value) {
                        if (value == null) return;
                        setState(() => _selectedCategory = value);
                      },
                    ),
                    SizedBox(width: 10,),
                    _buildDateSelectionRow(
                      selectedDate: _selectedDate,
                      onPickDate: _presentDatePicker,
                    )
              ],)
              else
              Row(
                children: [
                  Expanded(
                    child: 
                      _buildTitleTextField(
                        controller: _amountController,
                        label: 'Amount',
                        keyboardType: TextInputType.number,
                        isAmount: true
                      ),
                  ),
                  const SizedBox(width: 16,),
                  _buildDateSelectionRow(
                    selectedDate: _selectedDate,
                    onPickDate: _presentDatePicker,
                  )
                ],
              ),
              SizedBox(height: 20,),
              if (width >= 600)
              Row(children: [
                Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text('Cancel')),
                    SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: _summitExpenseData,
                    child: const Text('Save Expense')),
              ],)
              else
              Row(
                children: [
                  _buildCategoryDropdown(
                    selectedValue: _selectedCategory,
                    onChanged: (value) {
                      if (value == null) return;
                      setState(() => _selectedCategory = value);
                    },
                  ),
                  Spacer(),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    }, 
                    child: Text('Cancel')),
                    SizedBox(width: 10,),
                  ElevatedButton(
                    onPressed: _summitExpenseData,
                    child: const Text('Save Expense')),
                ],
              )
            ];
      return SizedBox(
      height: double.infinity,
      child: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 50, 16, keyboardSpace + 16),
          child: Column(
            children: children,
          ),),
      ),
    );
    });

    
  }

TextField _buildTitleTextField({
  required TextEditingController controller,
  required String label,
  required TextInputType keyboardType,
  required bool isAmount,
  int maxLength = 30,
  String prefixText = '\$ '
}) {
  return TextField(
    controller: controller,
    maxLength: maxLength,
    keyboardType: keyboardType,
    decoration: InputDecoration(
      label: Text(label),
      prefixText:(isAmount)?  prefixText :''
    ),
  );
}

//DropDown function
DropdownButton<Category> _buildCategoryDropdown({
  required Category selectedValue,
  required ValueChanged<Category?> onChanged,
}) {
  return DropdownButton<Category>(
    value: selectedValue,
    items: Category.values.map((category) => DropdownMenuItem(
      value: category,
      child: Text(category.name.toUpperCase()),
    )).toList(),
    onChanged: onChanged,
  );
}

Expanded _buildDateSelectionRow({
  required DateTime? selectedDate,
  required VoidCallback onPickDate,
}) {
  return Expanded(
    child: Row(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(selectedDate == null
            ? 'No date selected'
            : formatter.format(selectedDate!)),
        IconButton(
          onPressed: onPickDate,
          icon: const Icon(Icons.calendar_month),
        ),
      ],
    ),
  );
}


}