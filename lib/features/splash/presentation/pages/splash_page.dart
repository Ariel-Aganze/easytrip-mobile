import 'package:flutter/material.dart';

import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/shared/widgets/app_logo.dart';

/// The opening animation. Shown while [AuthBloc] resolves the session
/// (state == AuthInitial); the router redirects away once it resolves.
class SplashPage extends StatefulWidget {
  const SplashPage({super.key});

  @override
  State<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends State<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _markScale;
  late final Animation<double> _markFade;
  late final Animation<double> _wordFade;
  late final Animation<Offset> _wordSlide;
  late final Animation<double> _taglineFade;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _markScale = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.55, curve: Curves.easeOutBack),
      ),
    );
    _markFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.0, 0.4, curve: Curves.easeOut),
    );
    _wordFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.35, 0.7, curve: Curves.easeOut),
    );
    _wordSlide =
        Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
      ),
    );
    _taglineFade = CurvedAnimation(
      parent: _controller,
      curve: const Interval(0.6, 1.0, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      backgroundColor: scheme.primary,
      body: SafeArea(
        child: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  FadeTransition(
                    opacity: _markFade,
                    child: ScaleTransition(
                      scale: _markScale,
                      child: AppLogo(
                        size: 96,
                        showWordmark: false,
                        markColor: scheme.onPrimary,
                        markIconColor: scheme.primary,
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),
                  SlideTransition(
                    position: _wordSlide,
                    child: FadeTransition(
                      opacity: _wordFade,
                      child: Text(
                        'EasyTrip',
                        style: TextStyle(
                          fontSize: 40,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -1,
                          color: scheme.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  FadeTransition(
                    opacity: _taglineFade,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 40),
                      child: Text(
                        l10n.tagline,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: scheme.onPrimary.withOpacity(0.85),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 40),
                child: FadeTransition(
                  opacity: _taglineFade,
                  child: SizedBox(
                    width: 26,
                    height: 26,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.6,
                      valueColor:
                          AlwaysStoppedAnimation<Color>(scheme.onPrimary),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
