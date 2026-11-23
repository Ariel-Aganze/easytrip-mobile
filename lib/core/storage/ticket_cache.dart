import 'dart:convert';

import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// On-device copy of the traveller's tickets so the QR code can be shown at the
/// boarding gate without a signal (SRS §17). Stored encrypted (the QR token is
/// effectively a bearer credential) and wiped on logout.
class TicketCache {
  TicketCache(this._storage);

  final FlutterSecureStorage _storage;
  static const _key = 'easytrip.tickets.v1';

  Future<List<Map<String, dynamic>>> read() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return const [];
      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      return (decoded['tickets'] as List).cast<Map<String, dynamic>>();
    } catch (_) {
      return const []; // corrupt or unreadable cache: behave as empty
    }
  }

  Future<DateTime?> savedAt() async {
    try {
      final raw = await _storage.read(key: _key);
      if (raw == null) return null;
      return DateTime.tryParse(
          (jsonDecode(raw) as Map<String, dynamic>)['saved_at'] as String);
    } catch (_) {
      return null;
    }
  }

  Future<void> write(List<Map<String, dynamic>> tickets) => _storage.write(
        key: _key,
        value: jsonEncode(
            {'saved_at': DateTime.now().toIso8601String(), 'tickets': tickets}),
      );

  Future<void> clear() => _storage.delete(key: _key);
}
