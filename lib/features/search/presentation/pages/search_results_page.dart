import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/domain/entities/sort_mode.dart';
import 'package:easytrip/features/search/presentation/cubit/search_results_cubit.dart';
import 'package:easytrip/features/search/presentation/widgets/trip_card.dart';
import 'package:easytrip/features/trip/presentation/pages/trip_detail_page.dart';

class SearchResultsPage extends StatelessWidget {
  const SearchResultsPage({
    super.key,
    required this.query,
  });

  final SearchQuery query;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchResultsCubit>(
      create: (_) => sl<SearchResultsCubit>()..run(query),
      child: _ResultsView(query: query),
    );
  }
}

class _ResultsView extends StatelessWidget {
  const _ResultsView({
    required this.query,
  });

  final SearchQuery query;

  String _sortLabel(
    AppLocalizations l10n,
    TripSortMode mode,
  ) {
    return switch (mode) {
      TripSortMode.recommended => l10n.sortRecommended,
      TripSortMode.cheapest => l10n.sortCheapest,
      TripSortMode.fastest => l10n.sortFastest,
      TripSortMode.highestRated => l10n.sortTopRated,
    };
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${query.originName} → ${query.destinationName}',
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
              ),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              '${MaterialLocalizations.of(context).formatMediumDate(query.date)} · '
              '${l10n.searchPassengers}: ${query.passengers}',
              style: textTheme.bodySmall,
            ),
          ],
        ),
      ),
      body: BlocBuilder<SearchResultsCubit, SearchResultsState>(
        builder: (context, state) {
          return Column(
            children: [
              _SortBar(
                current: state.sort,
                labelFor: (mode) => _sortLabel(l10n, mode),
                onChanged: (mode) {
                  context.read<SearchResultsCubit>().changeSort(mode);
                },
              ),
              Expanded(
                child: _body(
                  context,
                  state,
                  l10n,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _body(
    BuildContext context,
    SearchResultsState state,
    AppLocalizations l10n,
  ) {
    switch (state.status) {
      case LoadStatus.idle:
      case LoadStatus.loading:
        return const Center(
          child: CircularProgressIndicator(),
        );

      case LoadStatus.error:
        return _Message(
          icon: Icons.error_outline,
          title: l10n.resultsError,
          actionLabel: l10n.actionRetry,
          onAction: () {
            context.read<SearchResultsCubit>().run(
                  state.query ?? query,
                );
          },
        );

      case LoadStatus.ready:
        if (state.trips.isEmpty) {
          return _Message(
            icon: Icons.search_off,
            title: l10n.resultsEmptyTitle,
            subtitle: l10n.resultsEmptyBody,
          );
        }

        return ListView(
          padding: const EdgeInsets.fromLTRB(
            16,
            8,
            16,
            24,
          ),
          children: [
            Padding(
              padding: const EdgeInsets.only(
                bottom: 8,
                left: 4,
              ),
              child: Text(
                l10n.tripsFound(state.trips.length),
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
              ),
            ),
            for (final trip in state.trips)
              TripCard(
                trip: trip,
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => TripDetailPage(
                        tripId: trip.id,
                        passengers: query.passengers,
                      ),
                    ),
                  );
                },
              ),
          ],
        );
    }
  }
}

class _SortBar extends StatelessWidget {
  const _SortBar({
    required this.current,
    required this.labelFor,
    required this.onChanged,
  });

  final TripSortMode current;
  final String Function(TripSortMode) labelFor;
  final ValueChanged<TripSortMode> onChanged;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 56,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        children: [
          for (final mode in TripSortMode.values)
            Padding(
              padding: const EdgeInsets.only(right: 8),
              child: ChoiceChip(
                label: Text(labelFor(mode)),
                selected: mode == current,
                onSelected: (_) => onChanged(mode),
              ),
            ),
        ],
      ),
    );
  }
}

class _Message extends StatelessWidget {
  const _Message({
    required this.icon,
    required this.title,
    this.subtitle,
    this.actionLabel,
    this.onAction,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 48,
              color: scheme.onSurfaceVariant,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w600,
              ),
            ),
            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                textAlign: TextAlign.center,
                style: textTheme.bodyMedium?.copyWith(
                  color: scheme.onSurfaceVariant,
                ),
              ),
            ],
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: onAction,
                icon: const Icon(Icons.refresh),
                label: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
