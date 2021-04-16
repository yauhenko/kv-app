class User {
  int id;
  String name;
  double balance;
  List<String> phones;
  Flat? flat;

  User(this.id, this.name, this.balance, this.phones, [this.flat]);

  factory User.fromJson(Map json) {
    return User(
      int.parse(json['u_id']),
      json['u_name'],
      double.parse(json['u_balance']),
      (json['u_tel'] as String).split(','),
      json['flat'] != null ? Flat.fromJson(json['flat']) : null,
    );
  }

  @override
  String toString() {
    return "[ID:$id] $name ($balance\$); Flat: $flat";
  }
}

class Flat {
  int id;
  String address;
  double price;

  Flat(this.id, this.address, this.price);

  factory Flat.fromJson(Map json) {
    return Flat(
      int.parse(json['flat_id']),
      json['flat_addr'],
      double.parse(json['flat_price']),
    );
  }

  @override
  String toString() {
    return "[ID:$id] $address ($price\$)";
  }
}

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

class Counter {
  int id;
  String type;
  String name;
  CounterRecord? last;

  Counter(this.id, this.type, this.name, [this.last]);

  factory Counter.fromJson(Map json) {
    return Counter(
      int.parse(json['cnt_id']),
      json['cnt_type'],
      json['cnt_name'],
      json['last'] != null ? CounterRecord.fromJson(json['last']) : null,
    );
  }

  @override
  String toString() {
    return '{Counter #$id: type: $type, name: $name, last: $last}';
  }
}

class CounterRecord {
  int id;
  num value;
  DateTime date;
  String period;

  CounterRecord(this.id, this.value, this.date, this.period);

  factory CounterRecord.fromJson(Map json) {
    return CounterRecord(
      int.parse(json['val_id']),
      double.parse(json['val_value']),
      DateTime.parse(json['val_date']),
      json['val_period'],
    );
  }

  @override
  String toString() {
    return '{CounterRecord #$id: value: $value, date: $date}';
  }

}
