import 'record.dart';

class Counter {
  int id;
  String type;
  String name;
  Record? last;

  Counter(this.id, this.type, this.name, [this.last]);

  factory Counter.fromJson(Map json) {
    return Counter(
      int.parse(json['cnt_id']),
      json['cnt_type'],
      json['cnt_name'],
      json['last'] != null ? Record.fromJson(json['last']) : null,
    );
  }

  @override
  String toString() {
    return '{Counter #$id: type: $type, name: $name, last: $last}';
  }
}