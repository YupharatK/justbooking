import 'package:flutter/material.dart';
import 'package:just_booking/l10n/generated/app_localizations.dart';

extension LocalizationExt on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this)!;
}

extension BookingStatusExt on String {
  String translateBookingStatus(BuildContext context) {
    final l10n = context.l10n;
    switch (this) {
      case 'pending_owner_approval':
        return l10n.bookingStatusPendingOwnerApproval;
      case 'pending_payment':
        return l10n.bookingStatusPendingPayment;
      case 'pending_payment_verification':
        return l10n.bookingStatusPendingPaymentVerification;
      case 'completed':
      case 'confirmed':
        return 'อนุมัติการเช่าแล้ว';
      case 'rejected':
        return l10n.bookingStatusRejected;
      case 'cancelled':
        return l10n.bookingStatusCancelled;
      default:
        return this; // Fallback to raw status if unknown
    }
  }
}
