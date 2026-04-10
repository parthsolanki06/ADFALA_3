import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';

class AddExpenseScreen extends StatefulWidget {
  @override
  _AddExpenseScreenState createState() => _AddExpenseScreenState();
}

class _AddExpenseScreenState extends State<AddExpenseScreen> {
  final titleController = TextEditingController();
  final amountController = TextEditingController();

  String category = "Food";
  bool isIncome = false;
  DateTime selectedDate = DateTime.now();

  final box = Hive.box('expenses');

  void save() {
    if (titleController.text.isEmpty || amountController.text.isEmpty) return;

    final exp = Expense(
      title: titleController.text,
      amount: double.parse(amountController.text),
      category: category,
      date: selectedDate.toString(),
      isIncome: isIncome,
    );

    box.add(exp.toMap());
    Navigator.pop(context);
  }

  Future pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2100),
    );

    if (picked != null) {
      setState(() => selectedDate = picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add Expense")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          children: [
            // Title
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                labelText: "Title / Topic",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            // Amount
            TextField(
              controller: amountController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Amount",
                prefixText: "₹ ",
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 15),

            // Category Dropdown
            DropdownButtonFormField<String>(
              value: category,
              decoration: InputDecoration(
                labelText: "Category",
                border: OutlineInputBorder(),
              ),
              items: ["Food", "Shopping", "Travel", "Health"]
                  .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                  .toList(),
              onChanged: (val) => setState(() => category = val!),
            ),

            SizedBox(height: 15),

            // Date Picker
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
                side: BorderSide(color: Colors.grey),
              ),
              title: Text("Date"),
              subtitle: Text("${selectedDate.toLocal()}".split(' ')[0]),
              trailing: Icon(Icons.calendar_today),
              onTap: pickDate,
            ),

            SizedBox(height: 15),

            // Income Toggle
            SwitchListTile(
              title: Text("Is Income?"),
              value: isIncome,
              onChanged: (val) => setState(() => isIncome = val),
            ),

            SizedBox(height: 20),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
              onPressed: save,
              child: Text("Save Expense"),
            )
          ],
        ),
      ),
    );
  }
}