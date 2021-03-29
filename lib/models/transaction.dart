class Transaction {
  String id;
  String title;
  double amount;
  DateTime date;

  Transaction({
    this.id,
    this.title,
    this.amount,
    this.date,
  });

  Transaction.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        title = json['title'],
        amount = json['amount'],
        date = DateTime.parse(json['date']);

  Map<String, dynamic> toJson() {
    return {
      'id': this.id,
      'title': this.title,
      'amount': this.amount,
      'date': this.date.toString()
    };
  }
}
