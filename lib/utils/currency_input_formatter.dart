import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

/// A TextInputFormatter that formats numbers with comma separators
/// as the user types. Example: 1000000 → 1,000,000
class CurrencyInputFormatter extends TextInputFormatter {
  final NumberFormat _formatter = NumberFormat('#,###', 'en_US');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    // If the new value is empty, return it as is
    if (newValue.text.isEmpty) {
      return newValue;
    }

    // Remove all non-digit characters
    final digitsOnly = newValue.text.replaceAll(RegExp(r'[^\d]'), '');

    // If there are no digits, return empty
    if (digitsOnly.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    // Parse the number
    final number = int.tryParse(digitsOnly);
    if (number == null) {
      return oldValue;
    }

    // Format with commas
    final formatted = _formatter.format(number);

    // Calculate the new cursor position
    // Count how many digits are before the cursor in the new value
    final cursorPosition = newValue.selection.end;
    int digitsBeforeCursor = 0;
    for (int i = 0; i < cursorPosition && i < newValue.text.length; i++) {
      if (RegExp(r'\d').hasMatch(newValue.text[i])) {
        digitsBeforeCursor++;
      }
    }

    // Find the position in the formatted string that corresponds to
    // the same number of digits
    int newCursorPosition = 0;
    int digitCount = 0;
    for (int i = 0; i < formatted.length; i++) {
      if (digitCount >= digitsBeforeCursor) {
        newCursorPosition = i;
        break;
      }
      if (RegExp(r'\d').hasMatch(formatted[i])) {
        digitCount++;
      }
      newCursorPosition = i + 1;
    }

    return TextEditingValue(
      text: formatted,
      selection: TextSelection.collapsed(offset: newCursorPosition),
    );
  }

  /// Helper method to parse a formatted currency string back to a number
  static double? parse(String text) {
    final digitsOnly = text.replaceAll(RegExp(r'[^\d]'), '');
    if (digitsOnly.isEmpty) return null;
    return double.tryParse(digitsOnly);
  }
}
