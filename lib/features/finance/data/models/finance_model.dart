import '../../domain/entities/finance.dart';

class FinanceModel extends Finance {
  FinanceModel({
    required int id,
    required String type,
    required double amount,
    required String description,
    required String date,
  }) : super(
          id: id,
          type: type,
          amount: amount,
          description: description,
          date: date,
        );

  factory FinanceModel.fromJson(Map<String, dynamic> json) {
    return FinanceModel(
      id: json['id'],
      type: json['type'],
      amount: (json['amount'] as num).toDouble(),
      description: json['description'],
      date: json['date'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type,
        'amount': amount,
        'description': description,
        'date': date,
      };
}
