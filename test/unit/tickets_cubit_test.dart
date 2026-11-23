import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:easytrip/core/error/failure.dart';
import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket.dart';
import 'package:easytrip/features/ticket/domain/entities/ticket_status.dart';
import 'package:easytrip/features/ticket/domain/repositories/ticket_repository.dart';
import 'package:easytrip/features/ticket/presentation/cubit/tickets_cubit.dart';

Ticket _ticket(String id) => Ticket(
      id: id,
      ticketNumber: 'TKT-$id',
      bookingReference: 'BK-1',
      origin: 'Goma',
      destination: 'Kigali',
      departure: DateTime(2026, 11, 25, 7),
      operatorName: 'ABC',
      vehicle: 'Bus',
      passengerName: 'Ariel',
      seatNumber: '1',
      amount: 20,
      currency: 'USD',
      paymentStatus: 'PAID',
      status: TicketStatus.fromApi('VALID'),
      qrToken: 'qr-$id',
    );

class _FakeRepo implements TicketRepository {
  _FakeRepo({required this.cached, required this.remote});
  final List<Ticket> cached;
  final Result<List<Ticket>> remote;
  @override
  Future<List<Ticket>> getCachedTickets() async => cached;
  @override
  Future<Result<List<Ticket>>> getMyTickets() async => remote;
}

void main() {
  blocTest<TicketsCubit, TicketsState>(
    'shows saved tickets at once, then fresh ones',
    build: () => TicketsCubit(
        _FakeRepo(cached: [_ticket('old')], remote: Ok([_ticket('new')]))),
    act: (c) => c.load(),
    expect: () => [
      isA<TicketsState>()
          .having((s) => s.status, 'status', LoadStatus.loading)
          .having((s) => s.tickets.single.id, 'cached', 'old'),
      isA<TicketsState>()
          .having((s) => s.status, 'status', LoadStatus.ready)
          .having((s) => s.tickets.single.id, 'fresh', 'new')
          .having((s) => s.offline, 'offline', false),
    ],
  );

  blocTest<TicketsCubit, TicketsState>(
    'offline: keeps the saved tickets (QR still usable) and flags offline',
    build: () => TicketsCubit(_FakeRepo(
        cached: [_ticket('old')], remote: const Err(NetworkFailure()))),
    act: (c) => c.load(),
    skip: 1,
    expect: () => [
      isA<TicketsState>()
          .having((s) => s.status, 'status', LoadStatus.ready)
          .having((s) => s.offline, 'offline', true)
          .having((s) => s.tickets.single.qrToken, 'qr', 'qr-old'),
    ],
  );

  blocTest<TicketsCubit, TicketsState>(
    'no saved tickets and no network is an error',
    build: () => TicketsCubit(
        _FakeRepo(cached: const [], remote: const Err(NetworkFailure()))),
    act: (c) => c.load(),
    skip: 1,
    expect: () => [
      isA<TicketsState>().having((s) => s.status, 'status', LoadStatus.error)
    ],
  );
}
