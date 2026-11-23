import 'package:flutter/material.dart';

import 'package:easytrip/core/utils/money_formatter.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/search/domain/entities/trip_summary.dart';

/// A single search result. Tapping it selects the trip (next step: seat map).
class TripCard extends StatelessWidget {
  const TripCard({super.key, required this.trip, this.onTap});

  final TripSummary trip;
  final VoidCallback? onTap;

  String _time(BuildContext context, DateTime dt) {
    return MaterialLocalizations.of(context)
        .formatTimeOfDay(TimeOfDay.fromDateTime(dt));
  }

  String _duration(int? minutes) {
    if (minutes == null || minutes <= 0) return '—';
    final h = minutes ~/ 60;
    final m = minutes % 60;
    if (h == 0) return '${m}m';
    if (m == 0) return '${h}h';
    return '${h}h ${m}m';
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final l10n = AppLocalizations.of(context);

    final arrival = trip.arrival;
    final seatsLow = trip.seatsAvailable > 0 && trip.seatsAvailable <= 5;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      color: scheme.surfaceContainerLow,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(18),
        side: BorderSide(color: scheme.outlineVariant),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(18),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Operator + rating
              Row(
                children: [
                  Expanded(
                    child: Text(
                      trip.operatorName,
                      style: textTheme.titleMedium
                          ?.copyWith(fontWeight: FontWeight.w700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (trip.hasRating)
                    Row(
                      children: [
                        Icon(Icons.star_rounded,
                            size: 18, color: scheme.tertiary),
                        const SizedBox(width: 2),
                        Text(
                          trip.ratingAverage.toStringAsFixed(1),
                          style: textTheme.labelLarge
                              ?.copyWith(fontWeight: FontWeight.w700),
                        ),
                        Text(
                          ' (${trip.ratingCount})',
                          style: textTheme.bodySmall
                              ?.copyWith(color: scheme.onSurfaceVariant),
                        ),
                      ],
                    )
                  else
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: scheme.secondaryContainer,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        l10n.tripNew,
                        style: textTheme.labelSmall
                            ?.copyWith(color: scheme.onSecondaryContainer),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // Times + duration
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _time(context, trip.departure),
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          Text(
                            _duration(trip.durationMinutes),
                            style: textTheme.bodySmall
                                ?.copyWith(color: scheme.onSurfaceVariant),
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              Expanded(
                                  child: Divider(
                                      color: scheme.outlineVariant, height: 1)),
                              Icon(Icons.directions_bus_rounded,
                                  size: 16, color: scheme.onSurfaceVariant),
                              Expanded(
                                  child: Divider(
                                      color: scheme.outlineVariant, height: 1)),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                  Text(
                    arrival != null ? _time(context, arrival) : '—',
                    style: textTheme.titleLarge
                        ?.copyWith(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                trip.vehicleType,
                style: textTheme.bodySmall
                    ?.copyWith(color: scheme.onSurfaceVariant),
              ),

              const SizedBox(height: 14),
              Divider(color: scheme.outlineVariant, height: 1),
              const SizedBox(height: 12),

              // Seats + price
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Text(
                      l10n.tripSeatsLeft(trip.seatsAvailable),
                      style: textTheme.bodyMedium?.copyWith(
                        color:
                            seatsLow ? scheme.error : scheme.onSurfaceVariant,
                        fontWeight:
                            seatsLow ? FontWeight.w600 : FontWeight.w400,
                      ),
                    ),
                  ),
                  Text(
                    Money.format(trip.price, trip.currency),
                    style: textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: scheme.primary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
