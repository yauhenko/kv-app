import 'flat.dart';

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
