import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// A supported country and its E.164 dialing code.
class PhoneCountry {
  const PhoneCountry(this.flag, this.dialCode, this.iso);
  final String flag;
  final String dialCode; // e.g. "+243"
  final String iso; // e.g. "CD"
}

/// The four launch markets (brief: DRC · Rwanda · Uganda · Kenya).
const List<PhoneCountry> kSupportedCountries = [
  PhoneCountry('🇨🇩', '+243', 'CD'),
  PhoneCountry('🇷🇼', '+250', 'RW'),
  PhoneCountry('🇺🇬', '+256', 'UG'),
  PhoneCountry('🇰🇪', '+254', 'KE'),
];

/// A phone number input with a country-code selector. Emits the composed E.164
/// value (e.g. `+243991234567`) via [onChanged], or an empty string when the
/// national part is blank.
class PhoneField extends StatefulWidget {
  const PhoneField({
    super.key,
    required this.onChanged,
    this.label,
    this.hint,
    this.errorText,
    this.enabled = true,
  });

  final ValueChanged<String> onChanged;
  final String? label;
  final String? hint;
  final String? errorText;
  final bool enabled;

  @override
  State<PhoneField> createState() => _PhoneFieldState();
}

class _PhoneFieldState extends State<PhoneField> {
  PhoneCountry _country = kSupportedCountries.first;
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _emit() {
    final digits = _controller.text.replaceAll(RegExp(r'\D'), '');
    final national = digits.startsWith('0') ? digits.substring(1) : digits;
    widget.onChanged(national.isEmpty ? '' : '${_country.dialCode}$national');
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return TextField(
      controller: _controller,
      enabled: widget.enabled,
      keyboardType: TextInputType.phone,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[0-9 ]')),
      ],
      onChanged: (_) => _emit(),
      decoration: InputDecoration(
        labelText: widget.label,
        hintText: widget.hint,
        errorText: widget.errorText,
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 12, right: 4),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<PhoneCountry>(
              value: _country,
              isDense: true,
              borderRadius: BorderRadius.circular(12),
              onChanged: widget.enabled
                  ? (value) {
                      if (value == null) return;
                      setState(() => _country = value);
                      _emit();
                    }
                  : null,
              items: [
                for (final c in kSupportedCountries)
                  DropdownMenuItem<PhoneCountry>(
                    value: c,
                    child: Text(
                      '${c.flag}  ${c.dialCode}',
                      style: TextStyle(
                        fontSize: 15,
                        color: scheme.onSurface,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
        prefixIconConstraints: const BoxConstraints(minWidth: 0, minHeight: 0),
      ),
    );
  }
}
