import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/customer.dart';
import '../models/loan.dart';
import '../models/payment.dart';

class StorageService extends ChangeNotifier {
  static const String _customersKey = 'customers';
  static const String _loansKey = 'loans';
  static const String _paymentsKey = 'payments';

  List<Customer> _customers = [];
  List<Loan> _loans = [];
  List<Payment> _payments = [];

  List<Customer> get customers => _customers;
  List<Loan> get loans => _loans;
  List<Payment> get payments => _payments;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();

    final customersData = prefs.getString(_customersKey);
    if (customersData != null && customersData.isNotEmpty) {
      _customers = Customer.decode(customersData);
    }

    final loansData = prefs.getString(_loansKey);
    if (loansData != null && loansData.isNotEmpty) {
      _loans = Loan.decode(loansData);
    }

    final paymentsData = prefs.getString(_paymentsKey);
    if (paymentsData != null && paymentsData.isNotEmpty) {
      _payments = Payment.decode(paymentsData);
    }

    notifyListeners();
  }

  Future<void> _saveCustomers() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_customersKey, Customer.encode(_customers));
  }

  Future<void> _saveLoans() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_loansKey, Loan.encode(_loans));
  }

  Future<void> _savePayments() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_paymentsKey, Payment.encode(_payments));
  }

  // Customer operations
  Future<void> addCustomer(Customer customer) async {
    _customers.add(customer);
    await _saveCustomers();
    notifyListeners();
  }

  Future<void> updateCustomer(Customer customer) async {
    final index = _customers.indexWhere((c) => c.id == customer.id);
    if (index != -1) {
      _customers[index] = customer;
      await _saveCustomers();
      notifyListeners();
    }
  }

  Future<void> deleteCustomer(String customerId) async {
    _customers.removeWhere((c) => c.id == customerId);
    _loans.removeWhere((l) => l.customerId == customerId);
    final loanIds = _loans
        .where((l) => l.customerId == customerId)
        .map((l) => l.id)
        .toSet();
    _payments.removeWhere((p) => loanIds.contains(p.loanId));
    await _saveCustomers();
    await _saveLoans();
    await _savePayments();
    notifyListeners();
  }

  Customer? getCustomerById(String id) {
    try {
      return _customers.firstWhere((c) => c.id == id);
    } catch (e) {
      return null;
    }
  }

  // Loan operations
  Future<void> addLoan(Loan loan) async {
    _loans.add(loan);
    await _saveLoans();
    notifyListeners();
  }

  Future<void> updateLoan(Loan loan) async {
    final index = _loans.indexWhere((l) => l.id == loan.id);
    if (index != -1) {
      _loans[index] = loan;
      await _saveLoans();
      notifyListeners();
    }
  }

  Future<void> deleteLoan(String loanId) async {
    _loans.removeWhere((l) => l.id == loanId);
    _payments.removeWhere((p) => p.loanId == loanId);
    await _saveLoans();
    await _savePayments();
    notifyListeners();
  }

  List<Loan> getLoansForCustomer(String customerId) {
    return _loans.where((l) => l.customerId == customerId).toList();
  }

  Loan? getLoanById(String id) {
    try {
      return _loans.firstWhere((l) => l.id == id);
    } catch (e) {
      return null;
    }
  }

  // Payment operations
  Future<void> addPayment(Payment payment) async {
    _payments.add(payment);
    await _savePayments();
    notifyListeners();
  }

  Future<void> deletePayment(String paymentId) async {
    _payments.removeWhere((p) => p.id == paymentId);
    await _savePayments();
    notifyListeners();
  }

  List<Payment> getPaymentsForLoan(String loanId) {
    return _payments.where((p) => p.loanId == loanId).toList();
  }

  double getTotalPaidForLoan(String loanId) {
    return _payments
        .where((p) => p.loanId == loanId)
        .fold(0.0, (sum, p) => sum + p.amount);
  }

  // Summary stats
  double get totalOutstandingLoans {
    double total = 0;
    for (final loan in _loans.where((l) => l.status == LoanStatus.active)) {
      total += loan.totalAmount - getTotalPaidForLoan(loan.id);
    }
    return total;
  }

  int get activeLoansCount =>
      _loans.where((l) => l.status == LoanStatus.active).length;

  List<Loan> get overdueLoans {
    final now = DateTime.now();
    return _loans
        .where((l) => l.status == LoanStatus.active && l.dueDate.isBefore(now))
        .toList();
  }
}
