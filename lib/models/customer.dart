import 'dart:convert';

class Customer {
  final String id;
  String name;
  String phone;
  String address;
  String notes;
  final DateTime createdAt;
  DateTime updatedAt;

  Customer({
    required this.id,
    required this.name,
    this.phone = '',
    this.address = '',
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'phone': phone,
    'address': address,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Customer.fromJson(Map<String, dynamic> json) => Customer(
    id: json['id'],
    name: json['name'],
    phone: json['phone'] ?? '',
    address: json['address'] ?? '',
    notes: json['notes'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  static String encode(List<Customer> customers) =>
      json.encode(customers.map((c) => c.toJson()).toList());

  static List<Customer> decode(String customersString) =>
      (json.decode(customersString) as List<dynamic>)
          .map((item) => Customer.fromJson(item))
          .toList();
}
