/// The Mobile Money networks the backend accepts (payments.Network).
enum PaymentNetwork {
  mpesa('MPESA', 'M-Pesa'),
  airtelMoney('AIRTEL_MONEY', 'Airtel Money'),
  orangeMoney('ORANGE_MONEY', 'Orange Money'),
  mtnMomo('MTN_MOMO', 'MTN MoMo');

  const PaymentNetwork(this.apiValue, this.label);
  final String apiValue;
  final String label;
}
