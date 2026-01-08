class Transaction {
  final int id;
  final String reference;
  final double amount;
  final double balanceAfter;
  final String type;
  final String? description;
  final String userName;
  //TODO Task2-1
  Transaction({
    required this.id,
    required this.reference,
    required this.amount,
    required this.balanceAfter,
    required this.type,
    this.description,
    required this.userName,
  });

  factory Transaction.fromJson(Map<String, dynamic> json) {
    return Transaction(
      id: json['id'],
      reference: json['reference'],
      amount: double.parse(json['amount']),
      balanceAfter: double.parse(json['balance_after']),
      type: json['type'],
      description: json['description'],
      userName: json['user']['name'],
    );
  }
}
