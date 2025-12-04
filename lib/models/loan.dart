import 'dart:convert';

enum LoanStatus { active, completed, overdue }

class Loan {
  final String id;
  final String customerId;
  double principal;
  double interestRate; // Annual percentage
  DateTime startDate;
  DateTime dueDate;
  LoanStatus status;
  String notes;
  final DateTime createdAt;
  DateTime updatedAt;

  Loan({
    required this.id,
    required this.customerId,
    required this.principal,
    this.interestRate = 0.0,
    required this.startDate,
    required this.dueDate,
    this.status = LoanStatus.active,
    this.notes = '',
    required this.createdAt,
    required this.updatedAt,
  });

  double get totalAmount {
    final months = dueDate.difference(startDate).inDays / 30;
    return principal + (principal * (interestRate / 100) * (months / 12));
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'customerId': customerId,
    'principal': principal,
    'interestRate': interestRate,
    'startDate': startDate.toIso8601String(),
    'dueDate': dueDate.toIso8601String(),
    'status': status.name,
    'notes': notes,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  factory Loan.fromJson(Map<String, dynamic> json) => Loan(
    id: json['id'],
    customerId: json['customerId'],
    principal: (json['principal'] as num).toDouble(),
    interestRate: (json['interestRate'] as num?)?.toDouble() ?? 0.0,
    startDate: DateTime.parse(json['startDate']),
    dueDate: DateTime.parse(json['dueDate']),
    status: LoanStatus.values.firstWhere(
      (s) => s.name == json['status'],
      orElse: () => LoanStatus.active,
    ),
    notes: json['notes'] ?? '',
    createdAt: DateTime.parse(json['createdAt']),
    updatedAt: DateTime.parse(json['updatedAt']),
  );

  static String encode(List<Loan> loans) =>
      json.encode(loans.map((l) => l.toJson()).toList());

  static List<Loan> decode(String loansString) =>
      (json.decode(loansString) as List<dynamic>)
          .map((item) => Loan.fromJson(item))
          .toList();
}
