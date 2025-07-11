class Finance {
  final int id;
  final String type; // e.g., 'income', 'expense'
  final double amount;
  final String description;
  final String date;

  Finance({
    required this.id,
    required this.type,
    required this.amount,
    required this.description,
    required this.date,
  });
}
