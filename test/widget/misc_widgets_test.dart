import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/features/booking/presentation/pages/payment_status_page.dart';
import 'package:easytrip/features/search/domain/entities/search_filters.dart';
import 'package:easytrip/features/search/presentation/widgets/filter_sheet.dart';

import 'helpers.dart';

void main() {
  testWidgets('hold countdown shows the time left, then the expiry message',
      (tester) async {
    final base = DateTime(2026, 11, 23, 10);
    var now = base;
    await tester.pumpWidget(localized(Scaffold(
      body: HoldCountdown(
          expiresAt: base.add(const Duration(minutes: 9, seconds: 5)),
          now: () => now),
    )));
    expect(find.text('Seat held for 09:05'), findsOneWidget);

    now = base.add(const Duration(minutes: 10));
    await tester.pump(const Duration(seconds: 1));
    expect(find.textContaining('The seat hold has expired'), findsOneWidget);
  });

  testWidgets('hold countdown in French', (tester) async {
    final now = DateTime(2026, 11, 23, 10);
    await tester.pumpWidget(localized(
      Scaffold(
          body: HoldCountdown(
              expiresAt: now.add(const Duration(minutes: 1)), now: () => now)),
      locale: const Locale('fr'),
    ));
    expect(find.text('Siège réservé pendant 01:00'), findsOneWidget);
  });

  testWidgets('filter sheet returns the chosen filters', (tester) async {
    SearchFilters? result;
    await tester.pumpWidget(localized(Builder(
      builder: (context) => Scaffold(
        body: TextButton(
          onPressed: () async {
            result = await showModalBottomSheet<SearchFilters>(
              context: context,
              isScrollControlled: true,
              builder: (_) =>
                  const FilterSheet(initial: SearchFilters(), currency: 'USD'),
            );
          },
          child: const Text('open'),
        ),
      ),
    )));
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Bus'));
    await tester.tap(find.text('Morning'));
    await tester.tap(find.text('4+ ★'));
    await tester.enterText(find.byKey(const Key('filter-max-price')), '30');
    await tester.ensureVisible(find.text('Show trips'));
    await tester.tap(find.text('Show trips'));
    await tester.pumpAndSettle();

    expect(result, isNotNull);
    expect(result!.toQuery(), {
      'vehicle_type': 'BUS',
      'depart_after': '00:00',
      'depart_before': '11:59',
      'max_price': '30',
      'min_rating': '4',
    });
  });
}
