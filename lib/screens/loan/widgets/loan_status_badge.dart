import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../models/loan.dart';
import '../../../theme/app_theme.dart';

/// Returns the color for the given loan status
Color getStatusColor(LoanStatus status) {
  switch (status) {
    case LoanStatus.active:
      return AppTheme.primaryDark;
    case LoanStatus.completed:
      return AppTheme.successColor;
  }
}

/// Returns the localized status text for a loan status
String getLocalizedStatus(LoanStatus status) {
  switch (status) {
    case LoanStatus.active:
      return 'loan.active'.tr();
    case LoanStatus.completed:
      return 'loan.completed'.tr();
  }
}

/// A badge widget that displays the loan status
class LoanStatusBadge extends StatelessWidget {
  final LoanStatus status;

  const LoanStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        getLocalizedStatus(status).toUpperCase(),
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Colors.white,
        ),
      ),
    );
  }
}
