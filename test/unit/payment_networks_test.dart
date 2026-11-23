import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/core/router/route_args.dart';
import 'package:easytrip/features/booking/domain/entities/payment_network.dart';
import 'package:easytrip/features/booking/presentation/pages/checkout_page.dart';

void main() {
  const gomaKigali = [
    PaymentOption(
        country: 'CD',
        callingCode: '+243',
        networks: ['MPESA', 'AIRTEL_MONEY', 'ORANGE_MONEY']),
    PaymentOption(
        country: 'RW',
        callingCode: '+250',
        networks: ['MTN_MOMO', 'AIRTEL_MONEY']),
  ];

  test('only networks offered in the trip countries are listed', () {
    expect(allowedNetworks(gomaKigali).toSet(), PaymentNetwork.values.toSet());
    const kenyaOnly = [
      PaymentOption(
          country: 'KE',
          callingCode: '+254',
          networks: ['MPESA', 'AIRTEL_MONEY'])
    ];
    expect(allowedNetworks(kenyaOnly),
        [PaymentNetwork.mpesa, PaymentNetwork.airtelMoney]);
  });

  test(
      'defaults to a network valid for the payer phone country (not MTN for a DRC number)',
      () {
    expect(defaultNetwork(gomaKigali, '+243990000001'), PaymentNetwork.mpesa);
    expect(defaultNetwork(gomaKigali, '+250780000001'), PaymentNetwork.mtnMomo);
    // unknown prefix: first network offered anywhere on the trip
    expect(allowedNetworks(gomaKigali),
        contains(defaultNetwork(gomaKigali, '+1555')));
  });

  test('no per-country config means any network', () {
    expect(allowedNetworks(const []), PaymentNetwork.values);
    expect(
        defaultNetwork(const [], '+243990000001'), PaymentNetwork.values.first);
  });
}
