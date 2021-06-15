// To parse this JSON data, do
//
//     final customer = customerFromJson(jsonString);

import 'dart:convert';

Customer customerFromJson(String str) => Customer.fromJson(json.decode(str));

String customerToJson(Customer data) => json.encode(data.toJson());

class Customer {
  Customer({
    this.username,
    this.password,
    this.phone,
    this.email,
    this.address,
  });

  String username;
  String password;
  String phone;
  String email;
  String address;

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
        username: json["username"],
        password: json["password"],
        phone: json["phone"],
        email: json["email"],
        address: json["address"],
      );

  Map<String, dynamic> toJson() => {
        "username": username,
        "password": password,
        "phone": phone,
        "email": email,
        "address": address,
      };
}
