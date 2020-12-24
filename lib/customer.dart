class Customer {
  String id, nama, telp;

  Customer(this.id, this.nama, this.telp);

  factory Customer.fromJson(Map<String, dynamic> json) {
    return Customer(
        json['idcustomer'],
        json['namacustomer'],
        json['telpcustomer']
    );
  }
}