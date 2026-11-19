import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/features/booking/domain/entities/payment.dart';
import 'package:easytrip/features/booking/domain/entities/payment_status.dart';

/// Wire model for payments PaymentSerializer.
class PaymentModel {
  const PaymentModel({
    required this.id,
    required this.reference,
    required this.bookingId,
    required this.status,
    required this.amount,
    required this.currency,
    required this.network,
  });

  final String id;
  final String reference;
  final String bookingId;
  final String status;
  final String amount;
  final String currency;
  final String network;

  factory PaymentModel.fromJson(Map<String, dynamic> json) {
    return PaymentModel(
      id: json['id'].toString(),
      reference: json['reference'] as String? ?? '',
      bookingId: json['booking']?.toString() ?? '',
      status: json['status'] as String? ?? 'PENDING',
      amount: json['amount']?.toString() ?? '0',
      currency: json['currency'] as String? ?? '',
      network: json['network'] as String? ?? '',
    );
  }

  Payment toEntity() {
    return Payment(
      id: id,
      reference: reference,
      bookingId: bookingId,
      status: PaymentStatus.fromApi(status),
      amount: Money.parse(amount),
      currency: currency,
      network: network,
    );
  }
}