import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/scanner/data/scanner_repository.dart';
import 'package:easytrip/l10n/app_localizations.dart';

/// Boarding check-in for agents and operators: scan → validate → green/red.
class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key, this.cameraBuilder});

  /// Replaces the camera in tests.
  final Widget Function(void Function(String) onCode)? cameraBuilder;

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  final _repo = sl<ScannerRepository>();
  bool _checking = false;
  Result<CheckIn>? _result;
  String? _lastCode;

  Future<void> _onCode(String code) async {
    if (_checking || _result != null || code == _lastCode) return;
    _lastCode = code;
    setState(() => _checking = true);
    final result = await _repo.validate(code);
    if (!mounted) return;
    HapticFeedback.mediumImpact();
    setState(() {
      _checking = false;
      _result = result;
    });
  }

  void _next() => setState(() {
        _result = null;
        _lastCode = null;
      });

  Future<void> _manualEntry() async {
    final l10n = AppLocalizations.of(context);
    final controller = TextEditingController();
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.enterTokenTitle),
        content: TextField(controller: controller, autofocus: true),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(l10n.actionCancel)),
          FilledButton(
              onPressed: () => Navigator.pop(ctx, controller.text.trim()),
              child: Text(l10n.checkInAction)),
        ],
      ),
    );
    controller.dispose();
    if (code != null && code.isNotEmpty) await _onCode(code);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.scanTickets),
        actions: [
          IconButton(
              tooltip: l10n.enterTokenTitle,
              onPressed: _manualEntry,
              icon: const Icon(Icons.keyboard)),
        ],
      ),
      body: Stack(
        fit: StackFit.expand,
        children: [
          widget.cameraBuilder?.call(_onCode) ??
              MobileScanner(
                onDetect: (capture) {
                  final value = capture.barcodes.firstOrNull?.rawValue;
                  if (value != null) _onCode(value);
                },
                errorBuilder: (context, error, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(l10n.cameraUnavailable,
                        textAlign: TextAlign.center),
                  ),
                ),
              ),
          if (_checking) const Center(child: CircularProgressIndicator()),
          if (_result != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
                color: switch (_result!) {
                  Ok() => Colors.green.shade700,
                  Err() => scheme.error
                },
                child: SafeArea(
                  top: false,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...switch (_result!) {
                        Ok(value: final c) => [
                            const Icon(Icons.check_circle,
                                color: Colors.white, size: 48),
                            Text(l10n.checkedIn,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(
                                '${c.passengerName} · ${l10n.seatLabel} ${c.seatNumber}',
                                style: const TextStyle(
                                    color: Colors.white, fontSize: 18)),
                            Text('${c.route} · ${c.ticketNumber}',
                                style: const TextStyle(color: Colors.white70)),
                          ],
                        Err(failure: final f) => [
                            const Icon(Icons.cancel,
                                color: Colors.white, size: 48),
                            Text(l10n.notValid,
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.w800)),
                            const SizedBox(height: 8),
                            Text(f.message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(color: Colors.white)),
                          ],
                      },
                      const SizedBox(height: 16),
                      FilledButton.tonal(
                          onPressed: _next, child: Text(l10n.scanNext)),
                    ],
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
