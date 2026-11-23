/// Formats money for the five supported currencies, using each currency's real
/// minor-unit precision (RWF/UGX have 0 decimals; USD/CDF/KES have 2) and
/// thousands separators. Reference data matches the backend's geo seed.
class Money {
  const Money._();

  static const _symbols = <String, String>{
    'USD': r'$',
    'CDF': 'FC',
    'RWF': 'FRw',
    'UGX': 'USh',
    'KES': 'KSh',
  };

  static const _decimals = <String, int>{
    'USD': 2,
    'CDF': 2,
    'RWF': 0,
    'UGX': 0,
    'KES': 2,
  };

  /// e.g. format(15000, 'RWF') -> "FRw 15,000"; format(12.5, 'USD') -> "$ 12.50"
  static String format(num amount, String currencyCode) {
    final code = currencyCode.toUpperCase();
    final decimals = _decimals[code] ?? 2;
    final symbol = _symbols[code] ?? code;

    final fixed = amount.toStringAsFixed(decimals);
    final dot = fixed.indexOf('.');
    final intPart = dot == -1 ? fixed : fixed.substring(0, dot);
    final fracPart = dot == -1 ? '' : fixed.substring(dot); // includes the '.'

    return '$symbol ${_group(intPart)}$fracPart';
  }

  /// Parses a backend price string ("15000.00") to a num, safely.
  static num parse(String raw) => num.tryParse(raw) ?? 0;

  static String _group(String digits) {
    final negative = digits.startsWith('-');
    final body = negative ? digits.substring(1) : digits;
    final buffer = StringBuffer();
    for (var i = 0; i < body.length; i++) {
      if (i != 0 && (body.length - i) % 3 == 0) buffer.write(',');
      buffer.write(body[i]);
    }
    return negative ? '-$buffer' : buffer.toString();
  }
}
