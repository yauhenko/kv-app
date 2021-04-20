class Record {
  int id;
  num value;
  DateTime date;
  String period;

  Record(this.id, this.value, this.date, this.period);

  factory Record.fromJson(Map json) {
    return Record(
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
