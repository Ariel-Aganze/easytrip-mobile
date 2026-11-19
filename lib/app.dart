import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/localization/locale_cubit.dart';
import 'package:easytrip/core/network/api_client.dart';
import 'package:easytrip/core/router/app_router.dart';
import 'package:easytrip/core/theme/app_theme.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';

class EasyTripApp extends StatefulWidget {
  const EasyTripApp({super.key});

  @override
  State<EasyTripApp> createState() => _EasyTripAppState();
}

class _EasyTripAppState extends State<EasyTripApp> {
  late final AuthBloc _authBloc;
  late final LocaleCubit _localeCubit;
  late final GoRouter _router;

  @override
  void initState() {
    super.initState();
    _authBloc = sl<AuthBloc>()..add(const AuthCheckRequested());
    _localeCubit = sl<LocaleCubit>();
    _router = buildRouter(_authBloc);

    // When the refresh token is dead, drop the session and route to login.
    sl<ApiClient>().onSessionExpired = () {
      if (!_authBloc.isClosed) _authBloc.add(const AuthLoggedOut());
    };
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>.value(value: _authBloc),
        BlocProvider<LocaleCubit>.value(value: _localeCubit),
      ],
      child: BlocBuilder<LocaleCubit, Locale>(
        builder: (context, locale) {
          return MaterialApp.router(
            title: 'EasyTrip',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light,
            darkTheme: AppTheme.dark,
            themeMode: ThemeMode.system,
            locale: locale,
            supportedLocales: AppLocalizations.supportedLocales,
            localizationsDelegates: AppLocalizations.localizationsDelegates,
            routerConfig: _router,
          );
        },
      ),
    );
  }
}