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