import 'package:flutter/material.dart';

import 'package:easytrip/features/search/domain/entities/search_filters.dart';
import 'package:easytrip/l10n/app_localizations.dart';

/// Bottom sheet to refine trip results. Pops the new [SearchFilters].
class FilterSheet extends StatefulWidget {
  const FilterSheet({super.key, required this.initial, required this.currency});

  final SearchFilters initial;
  final String currency;

  static const vehicleTypes = ['BUS', 'MINIBUS', 'VAN', 'TAXI'];
  static const amenityCodes = ['AC', 'WIFI', 'USB'];

  @override
  State<FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<FilterSheet> {
  late SearchFilters _f = widget.initial;
  late final _maxPrice =
      TextEditingController(text: widget.initial.maxPrice?.toString() ?? '');

  @override
  void dispose() {
    _maxPrice.dispose();
    super.dispose();
  }

  Set<String> _toggle(Set<String> set, String value) =>
      set.contains(value) ? ({...set}..remove(value)) : {...set, value};

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final title = Theme.of(context).textTheme.titleSmall;
    String vehicleLabel(String code) => switch (code) {
          'BUS' => l10n.vehicleBus,
          'MINIBUS' => l10n.vehicleMinibus,
          'VAN' => l10n.vehicleVan,
          'TAXI' => l10n.vehicleTaxi,
          _ => code,
        };
    String windowLabel(TimeOfDayWindow w) => switch (w) {
          TimeOfDayWindow.morning => l10n.timeMorning,
          TimeOfDayWindow.afternoon => l10n.timeAfternoon,
          TimeOfDayWindow.evening => l10n.timeEvening,
        };

    return SafeArea(
      child: Padding(
        padding: EdgeInsets.fromLTRB(
            20, 8, 20, 20 + MediaQuery.of(context).viewInsets.bottom),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(children: [
                Expanded(
                    child: Text(l10n.filtersTitle,
                        style: Theme.of(context).textTheme.titleLarge)),
                TextButton(
                  onPressed: () => setState(() {
                    _f = const SearchFilters();
                    _maxPrice.clear();
                  }),
                  child: Text(l10n.filtersClear),
                ),
              ]),
              const SizedBox(height: 8),
              Text(l10n.filterVehicle, style: title),
              Wrap(spacing: 8, children: [
                for (final v in FilterSheet.vehicleTypes)
                  FilterChip(
                    label: Text(vehicleLabel(v)),
                    selected: _f.vehicleTypes.contains(v),
                    onSelected: (_) => setState(() => _f =
                        _f.copyWith(vehicleTypes: _toggle(_f.vehicleTypes, v))),
                  ),
              ]),
              const SizedBox(height: 12),
              Text(l10n.filterDeparture, style: title),
              Wrap(spacing: 8, children: [
                for (final w in TimeOfDayWindow.values)
                  ChoiceChip(
                    label: Text(windowLabel(w)),
                    selected: _f.timeWindow == w,
                    onSelected: (on) => setState(() =>
                        _f = _f.copyWith(timeWindow: () => on ? w : null)),
                  ),
              ]),
              const SizedBox(height: 12),
              Text(l10n.filterRating, style: title),
              Wrap(spacing: 8, children: [
                for (final r in const [3, 4])
                  ChoiceChip(
                    label: Text('$r+ ★'),
                    selected: _f.minRating == r,
                    onSelected: (on) => setState(
                        () => _f = _f.copyWith(minRating: () => on ? r : null)),
                  ),
              ]),
              const SizedBox(height: 12),
              Text(l10n.filterAmenities, style: title),
              Wrap(spacing: 8, children: [
                for (final a in FilterSheet.amenityCodes)
                  FilterChip(
                    label: Text(a == 'AC'
                        ? l10n.amenityAc
                        : a == 'WIFI'
                            ? 'Wi-Fi'
                            : 'USB'),
                    selected: _f.amenities.contains(a),
                    onSelected: (_) => setState(() =>
                        _f = _f.copyWith(amenities: _toggle(_f.amenities, a))),
                  ),
              ]),
              const SizedBox(height: 12),
              TextField(
                key: const Key('filter-max-price'),
                controller: _maxPrice,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                decoration: InputDecoration(
                  labelText: l10n.filterMaxPrice,
                  suffixText: widget.currency,
                ),
                onChanged: (v) => _f = _f.copyWith(
                    maxPrice: () => num.tryParse(v.replaceAll(',', '.'))),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pop(_f),
                  child: Text(l10n.filtersApply),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
