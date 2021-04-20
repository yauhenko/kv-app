class Transaction {
  int id;
  double amount;
  double before;
  double after;
  String currency;
  DateTime date;
  String comment;

  Transaction(this.id, this.amount, this.before, this.after, this.currency, this.date, this.comment);

  factory Transaction.fromJson(Map json) {
    return Transaction(
      int.parse(json['tr_id']),
      double.parse(json['tr_amount']),
      double.parse(json['tr_before']),
      double.parse(json['tr_after']),
      json['tr_curr'],
      DateTime.parse(json['tr_date']),
      json['tr_comment'],
    );
  }

  @override
  String toString() {
    return "[ID:$id] $amount $currency ($comment)";
  }
}