import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/scanner/data/scanner_repository.dart';
import 'package:easytrip/features/scanner/presentation/pages/scanner_page.dart';

import 'helpers.dart';

class _FakeScanner extends ScannerRepository {
  _FakeScanner() : super(Dio());
  final scanned = <String>[];
  @override
  Future<Result<CheckIn>> validate(String qrToken) async {
    scanned.add(qrToken);
    if (qrToken == 'good') {
      return const Ok(CheckIn(
          passengerName: 'Ariel Aganze',
          seatNumber: '14',
          ticketNumber: 'TKT-1',
          route: 'Goma → Kigali'));
    }
    return const Err(
        ValidationFailure(message: 'This ticket has already been used.'));
  }
}

void main() {
  late _FakeScanner repo;
  late void Function(String) emit;

  setUp(() {
    repo = _FakeScanner();
    sl.allowReassignment = true;
    sl.registerSingleton<ScannerRepository>(repo);
  });
  tearDown(() => sl.reset());

  Widget page() => localized(ScannerPage(cameraBuilder: (onCode) {
        emit = onCode;
        return const ColoredBox(color: Colors.black);
      }));

  testWidgets('a valid ticket shows the passenger and seat', (tester) async {
    await tester.pumpWidget(page());
    emit('good');
    await tester.pumpAndSettle();
    expect(find.text('Passenger checked in'), findsOneWidget);
    expect(find.text('Ariel Aganze · Seat 14'), findsOneWidget);
  });

  testWidgets(
      'a used ticket is rejected; the same code is not re-sent while shown',
      (tester) async {
    await tester.pumpWidget(page());
    emit('used');
    await tester.pumpAndSettle();
    expect(find.text('Not valid'), findsOneWidget);
    expect(find.text('This ticket has already been used.'), findsOneWidget);

    emit('used'); // camera keeps seeing the same QR
    await tester.pumpAndSettle();
    expect(repo.scanned, ['used']);

    await tester.tap(find.text('Scan next'));
    await tester.pumpAndSettle();
    expect(find.text('Not valid'), findsNothing);
  });
}
