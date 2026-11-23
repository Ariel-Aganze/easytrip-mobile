import 'package:flutter/material.dart';

import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/geo/domain/entities/city.dart';

/// A tappable field that opens a searchable list of cities in a bottom sheet.
class CityPickerField extends StatelessWidget {
  const CityPickerField({
    super.key,
    required this.label,
    required this.icon,
    required this.cities,
    required this.selected,
    required this.onSelected,
    this.excludeId,
    this.errorText,
    this.enabled = true,
  });

  final String label;
  final IconData icon;
  final List<City> cities;
  final City? selected;
  final ValueChanged<City> onSelected;
  final String? excludeId;
  final String? errorText;
  final bool enabled;

  Future<void> _open(BuildContext context) async {
    final options =
        cities.where((c) => c.id != excludeId).toList(growable: false);
    final picked = await showModalBottomSheet<City>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (_) => _CityPickerSheet(cities: options),
    );
    if (picked != null) onSelected(picked);
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);
    final hasValue = selected != null;

    return InputDecorator(
      isEmpty: false,
      decoration: InputDecoration(
        labelText: label,
        errorText: errorText,
        prefixIcon: Icon(icon),
        suffixIcon: const Icon(Icons.expand_more),
      ),
      child: InkWell(
        onTap: enabled ? () => _open(context) : null,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 2),
          child: Text(
            hasValue ? selected!.name : l10n.searchSelectCity,
            style: TextStyle(
              fontSize: 16,
              color: hasValue ? scheme.onSurface : scheme.onSurfaceVariant,
            ),
          ),
        ),
      ),
    );
  }
}

class _CityPickerSheet extends StatefulWidget {
  const _CityPickerSheet({required this.cities});
  final List<City> cities;

  @override
  State<_CityPickerSheet> createState() => _CityPickerSheetState();
}

class _CityPickerSheetState extends State<_CityPickerSheet> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final filtered = _query.isEmpty
        ? widget.cities
        : widget.cities
            .where((c) => c.name.toLowerCase().contains(_query.toLowerCase()))
            .toList();

    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
              child: TextField(
                autofocus: true,
                onChanged: (v) => setState(() => _query = v),
                decoration: InputDecoration(
                  hintText: l10n.searchCitySearchHint,
                  prefixIcon: const Icon(Icons.search),
                ),
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: filtered.length,
                itemBuilder: (context, i) {
                  final city = filtered[i];
                  return ListTile(
                    leading: const Icon(Icons.location_on_outlined),
                    title: Text(city.name),
                    subtitle: Text(city.countryCode),
                    onTap: () => Navigator.of(context).pop(city),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
