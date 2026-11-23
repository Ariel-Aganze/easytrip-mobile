import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/notifications/data/notifications_repository.dart';
import 'package:easytrip/l10n/app_localizations.dart';

/// In-app inbox of the messages we sent (booking confirmed, cancelled, ...).
class NotificationsPage extends StatefulWidget {
  const NotificationsPage({super.key});

  @override
  State<NotificationsPage> createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  late Future<Result<List<AppNotification>>> _future =
      sl<NotificationsRepository>().inbox();

  Future<void> _refresh() async {
    final next = sl<NotificationsRepository>().inbox();
    setState(() => _future = next);
    await next;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final fmt =
        DateFormat.yMMMd(Localizations.localeOf(context).toString()).add_Hm();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.notificationsTitle)),
      body: FutureBuilder<Result<List<AppNotification>>>(
        future: _future,
        builder: (context, snap) {
          if (!snap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          return RefreshIndicator(
            onRefresh: _refresh,
            child: switch (snap.data!) {
              Err(failure: final f) => ListView(children: [
                  Padding(
                      padding: const EdgeInsets.all(24),
                      child: Text(f.message, textAlign: TextAlign.center)),
                ]),
              Ok(value: final items) when items.isEmpty => ListView(children: [
                  Padding(
                    padding: const EdgeInsets.all(48),
                    child: Text(l10n.notificationsEmpty,
                        textAlign: TextAlign.center),
                  ),
                ]),
              Ok(value: final items) => ListView.separated(
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (_, i) {
                    final n = items[i];
                    return ListTile(
                      leading: Icon(n.event.contains('CANCEL')
                          ? Icons.cancel_outlined
                          : Icons.check_circle_outline),
                      title: Text(n.title.isNotEmpty ? n.title : n.body,
                          maxLines: 1, overflow: TextOverflow.ellipsis),
                      subtitle: Text([
                        if (n.title.isNotEmpty) n.body,
                        if (n.at != null) fmt.format(n.at!)
                      ].join('\n')),
                      isThreeLine: n.title.isNotEmpty,
                    );
                  },
                ),
            },
          );
        },
      ),
    );
  }
}
