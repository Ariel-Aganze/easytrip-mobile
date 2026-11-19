import 'package:flutter/material.dart';

/// The EasyTrip brand mark: a rounded tile with a bus glyph, optionally followed
/// by the wordmark. Colors default to the theme but can be overridden (e.g. the
/// splash draws it in white on the green background).
class AppLogo extends StatelessWidget {
  const AppLogo({
    super.key,
    this.size = 56,
    this.showWordmark = true,
    this.markColor,
    this.markIconColor,
    this.wordmarkColor,
  });

  final double size;
  final bool showWordmark;
  final Color? markColor;
  final Color? markIconColor;
  final Color? wordmarkColor;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: markColor ?? scheme.primary,
            borderRadius: BorderRadius.circular(size * 0.28),
          ),
          child: Icon(
            Icons.directions_bus_rounded,
            color: markIconColor ?? scheme.onPrimary,
            size: size * 0.56,
          ),
        ),
        if (showWordmark) ...[
          SizedBox(width: size * 0.26),
          Text(
            'EasyTrip',
            style: TextStyle(
              fontSize: size * 0.5,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.5,
              color: wordmarkColor ?? scheme.onSurface,
            ),
          ),
        ],
      ],
    );
  }
}