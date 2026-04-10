class Expense {
  String title;
  double amount;
  String category;
  String date;
  bool isIncome;

  Expense({
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.isIncome,
  });

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'amount': amount,
      'category': category,
      'date': date,
      'isIncome': isIncome,
    };
  }

  factory Expense.fromMap(Map map) {
    return Expense(
      title: map['title'],
      amount: map['amount'],
      category: map['category'],
      date: map['date'],
      isIncome: map['isIncome'],
    );
  }
}