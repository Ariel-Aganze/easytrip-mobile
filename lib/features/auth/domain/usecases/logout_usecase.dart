import 'package:easytrip/core/storage/ticket_cache.dart';
import 'package:easytrip/features/auth/domain/repositories/auth_repository.dart';

class LogoutUseCase {
  const LogoutUseCase(this._repository, this._ticketCache);
  final AuthRepository _repository;
  final TicketCache _ticketCache;

  /// Ends the session and wipes per-user data from the device, so the next
  /// person to sign in on this phone can't see the previous user's tickets.
  Future<void> call() async {
    await _repository.logout();
    await _ticketCache.clear();
  }
}
