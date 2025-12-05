import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../models/loan.dart';
import '../../../theme/app_theme.dart';

/// Returns the color for the given loan status
Color getCustomerLoanStatusColor(LoanStatus status) {
  switch (status) {
    case LoanStatus.active:
      return AppTheme.accentColor;
    case LoanStatus.completed:
      return AppTheme.successColor;
  }
}

/// Returns the localized status text for a loan status
String getLocalizedLoanStatus(LoanStatus status) {
  switch (status) {
    case LoanStatus.active:
      return 'loan.active'.tr();
    case LoanStatus.completed:
      return 'loan.completed'.tr();
  }
}

/// A widget for displaying loan items in customer detail screen
class LoanListItem extends StatelessWidget {
  final Loan loan;
  final double paid;
  final double remaining;
  final double progress;
  final bool isDark;
  final NumberFormat currencyFormat;
  final VoidCallback onTap;

  const LoanListItem({
    super.key,
    required this.loan,
    required this.paid,
    required this.remaining,
    required this.progress,
    required this.isDark,
    required this.currencyFormat,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: AppTheme.cardDecoration(isDark),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: getCustomerLoanStatusColor(
                        loan.status,
                      ).withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      getLocalizedLoanStatus(loan.status).toUpperCase(),
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: getCustomerLoanStatusColor(loan.status),
                      ),
                    ),
                  ),
                  const Spacer(),
                  Text(
                    currencyFormat.format(loan.principal),
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: isDark ? Colors.white : const Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Icon(
                    Icons.calendar_today_rounded,
                    size: 14,
                    color: isDark ? Colors.grey[500] : Colors.grey[600],
                  ),
                  const SizedBox(width: 6),
                  Text(
                    DateFormat('MMM d, y').format(loan.startDate),
                    style: TextStyle(
                      fontSize: 13,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  value: progress.clamp(0.0, 1.0),
                  backgroundColor: isDark
                      ? Colors.white.withValues(alpha: 0.1)
                      : Colors.grey[200],
                  valueColor: AlwaysStoppedAnimation<Color>(
                    progress >= 1.0
                        ? AppTheme.successColor
                        : AppTheme.primaryDark,
                  ),
                  minHeight: 6,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    '${'loan.total_paid'.tr()}: ${currencyFormat.format(paid)}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppTheme.successColor,
                    ),
                  ),
                  Text(
                    '${'loan.remaining'.tr()}: ${currencyFormat.format(remaining)}',
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark ? Colors.grey[400] : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
