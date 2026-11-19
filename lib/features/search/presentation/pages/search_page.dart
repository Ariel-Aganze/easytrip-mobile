import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/load_status.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/geo/domain/entities/city.dart';
import 'package:easytrip/features/search/domain/entities/search_query.dart';
import 'package:easytrip/features/search/presentation/cubit/search_form_cubit.dart';
import 'package:easytrip/features/search/presentation/pages/search_results_page.dart';
import 'package:easytrip/features/search/presentation/widgets/city_picker_field.dart';

/// The "Search" tab content. Loads cities, collects the trip query, and pushes
/// the results screen.
class SearchPage extends StatelessWidget {
  const SearchPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SearchFormCubit>(
      create: (_) => sl<SearchFormCubit>()..loadCities(),
      child: const _SearchView(),
    );
  }
}

class _SearchView extends StatefulWidget {
  const _SearchView();

  @override
  State<_SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<_SearchView> {
  City? _origin;
  City? _destination;
  DateTime _date = DateTime.now();
  int _passengers = 1;
  bool _showErrors = false;

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final picked = await showDatePicker(
      context: context,
      initialDate: _date.isBefore(today) ? today : _date,
      firstDate: today,
      lastDate: today.add(const Duration(days: 180)),
    );
    if (picked != null) setState(() => _date = picked);
  }

  void _swap() {
    setState(() {
      final tmp = _origin;
      _origin = _destination;
      _destination = tmp;
    });
  }

  void _search() {
    setState(() => _showErrors = true);
    if (_origin == null || _destination == null || _origin!.id == _destination!.id) {
      return;
    }
    final query = SearchQuery(
      originId: _origin!.id,
      originName: _origin!.name,
      destinationId: _destination!.id,
      destinationName: _destination!.name,
      date: _date,
      passengers: _passengers,
    );
    Navigator.of(context).push(
      MaterialPageRoute<void>(builder: (_) => SearchResultsPage(query: query)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);

    return BlocBuilder<SearchFormCubit, SearchFormState>(
      builder: (context, state) {
        if (state.status == LoadStatus.loading || state.status == LoadStatus.idle) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.status == LoadStatus.error) {
          return _ErrorState(
            message: state.errorMessage ?? l10n.errorGeneric,
            onRetry: () => context.read<SearchFormCubit>().loadCities(),
          );
        }
        return _buildForm(context, state.cities, l10n);
      },
    );
  }

  Widget _buildForm(BuildContext context, List<City> cities, AppLocalizations l10n) {
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;
    final sameCity = _origin != null &&
        _destination != null &&
        _origin!.id == _destination!.id;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 560),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.searchTitle,
                style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 20),

              Stack(
                alignment: Alignment.centerRight,
                children: [
                  Column(
                    children: [
                      CityPickerField(
                        label: l10n.searchFrom,
                        icon: Icons.trip_origin,
                        cities: cities,
                        selected: _origin,
                        excludeId: _destination?.id,
                        errorText: _showErrors && _origin == null ? l10n.validationRequired : null,
                        onSelected: (c) => setState(() => _origin = c),
                      ),
                      const SizedBox(height: 12),
                      CityPickerField(
                        label: l10n.searchTo,
                        icon: Icons.place,
                        cities: cities,
                        selected: _destination,
                        excludeId: _origin?.id,
                        errorText: _showErrors && _destination == null
                            ? l10n.validationRequired
                            : (sameCity ? l10n.searchSameCityError : null),
                        onSelected: (c) => setState(() => _destination = c),
                      ),
                    ],
                  ),
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Material(
                      color: scheme.primary,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: l10n.searchSwapTooltip,
                        onPressed: _swap,
                        icon: Icon(Icons.swap_vert, color: scheme.onPrimary),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Date
              InkWell(
                onTap: _pickDate,
                borderRadius: BorderRadius.circular(16),
                child: InputDecorator(
                  decoration: InputDecoration(
                    labelText: l10n.searchDate,
                    prefixIcon: const Icon(Icons.calendar_today_outlined),
                  ),
                  child: Text(
                    MaterialLocalizations.of(context).formatMediumDate(_date),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // Passengers
              InputDecorator(
                decoration: InputDecoration(
                  labelText: l10n.searchPassengers,
                  prefixIcon: const Icon(Icons.people_outline),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('$_passengers', style: const TextStyle(fontSize: 16)),
                    Row(
                      children: [
                        IconButton.filledTonal(
                          onPressed: _passengers > 1
                              ? () => setState(() => _passengers--)
                              : null,
                          icon: const Icon(Icons.remove),
                        ),
                        const SizedBox(width: 8),
                        IconButton.filledTonal(
                          onPressed: _passengers < 9
                              ? () => setState(() => _passengers++)
                              : null,
                          icon: const Icon(Icons.add),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              FilledButton.icon(
                onPressed: _search,
                icon: const Icon(Icons.search),
                label: Text(l10n.searchButton),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message, required this.onRetry});
  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.error_outline, size: 44, color: scheme.error),
            const SizedBox(height: 12),
            Text(message, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: Text(l10n.actionRetry),
            ),
          ],
        ),
      ),
    );
  }
}