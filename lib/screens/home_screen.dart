import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import '../models/expense.dart';
import 'add_expense_screen.dart';
import 'package:fl_chart/fl_chart.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final box = Hive.box('expenses');

  List<Expense> getExpenses() {
    return box.values
        .map((e) => Expense.fromMap(Map<String, dynamic>.from(e)))
        .toList();
  }

  double getTotal(List<Expense> expenses) {
    return expenses.fold(
      0,
          (sum, item) => item.isIncome ? sum + item.amount : sum - item.amount,
    );
  }

  @override
  Widget build(BuildContext context) {
    final expenses = getExpenses();

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        title: Text("Welcome 👋"),
        elevation: 0,
        backgroundColor: Colors.grey[100],
      ),

      // 🔥 MAIN PART (Page Swipe)
      body: PageView(
        children: [
          // 🔹 PAGE 1: DASHBOARD
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                // Gradient Card
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.orange, Colors.red],
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Total Balance",
                          style: TextStyle(color: Colors.white70)),
                      SizedBox(height: 8),
                      Text(
                        "₹${getTotal(expenses)}",
                        style: TextStyle(
                          fontSize: 28,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),

                SizedBox(height: 20),

                // Expense List
                Expanded(
                  child: expenses.isEmpty
                      ? Center(child: Text("No data yet"))
                      : ListView.builder(
                    itemCount: expenses.length,
                    itemBuilder: (context, index) {
                      final exp = expenses[index];

                      return Dismissible(
                        key: Key(exp.date + index.toString()),
                        direction: DismissDirection.endToStart,
                        onDismissed: (direction) {
                          box.deleteAt(index);
                          setState(() {});
                        },
                        background: Container(
                          alignment: Alignment.centerRight,
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                            color: Colors.red,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child:
                          Icon(Icons.delete, color: Colors.white),
                        ),
                        child: Card(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.grey[200],
                              child: Icon(Icons.attach_money),
                            ),
                            title: Text(exp.title),
                            subtitle: Text(exp.category),
                            trailing: Text(
                              "${exp.isIncome ? "+" : "-"}₹${exp.amount}",
                              style: TextStyle(
                                color: exp.isIncome
                                    ? Colors.green
                                    : Colors.red,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          // 🔹 PAGE 2: ANALYTICS
          Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Text(
                  "Expenses",
                  style: TextStyle(
                      fontSize: 22, fontWeight: FontWeight.bold),
                ),

                SizedBox(height: 20),

                // Graph placeholder
                Container(
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.orange[100],
                    borderRadius: BorderRadius.circular(20),
                  ),
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: LineChart(
                        LineChartData(
                          gridData: FlGridData(show: false),
                          titlesData: FlTitlesData(show: false),
                          borderData: FlBorderData(show: false),
                          lineBarsData: [
                            LineChartBarData(
                              spots: [
                                FlSpot(0, 100),
                                FlSpot(1, 300),
                                FlSpot(2, 200),
                                FlSpot(3, 500),
                                FlSpot(4, 350),
                              ],
                              isCurved: true,
                              color: Colors.orange,
                              barWidth: 4,
                              dotData: FlDotData(show: false),
                            ),
                          ],
                        ),
                      ),
                    ),
                ),

                SizedBox(height: 20),

                // Category Grid
                Expanded(
                  child: GridView.count(
                    crossAxisCount: 2,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      _categoryCard("Shopping", "42%"),
                      _categoryCard("Food", "25%"),
                      _categoryCard("Travel", "20%"),
                      _categoryCard("Health", "13%"),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // ➕ FAB
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        child: Icon(Icons.add),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => AddExpenseScreen()),
          );
          setState(() {});
        },
      ),
    );
  }

  // 🔹 Category Card Widget
  Widget _categoryCard(String title, String percent) {
    Map<String, String> icons = {
      "Food": "🍔",
      "Shopping": "🛍️",
      "Travel": "✈️",
      "Health": "🏥",
    };

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(15),
        boxShadow: [
          BoxShadow(color: Colors.black12, blurRadius: 5),
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            icons[title] ?? "📦",
            style: TextStyle(fontSize: 28),
          ),
          SizedBox(height: 10),
          Text(title),
          SizedBox(height: 5),
          Text(
            percent,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ],
      ),
    );
  }
}