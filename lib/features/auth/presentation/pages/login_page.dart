import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/features/auth/presentation/cubit/login_cubit.dart';
import 'package:easytrip/features/auth/presentation/widgets/phone_field.dart';
import 'package:easytrip/shared/widgets/app_logo.dart';
import 'package:easytrip/shared/widgets/error_banner.dart';
import 'package:easytrip/shared/widgets/language_toggle_button.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LoginCubit>(
      create: (_) => sl<LoginCubit>(),
      child: const _LoginView(),
    );
  }
}

class _LoginView extends StatefulWidget {
  const _LoginView();

  @override
  State<_LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<_LoginView> {
  final _formKey = GlobalKey<FormState>();
  final _passwordController = TextEditingController();
  String _phone = '';
  String? _phoneError;
  bool _obscure = true;

  @override
  void dispose() {
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    final l10n = AppLocalizations.of(context);
    setState(() {
      _phoneError = _phone.isEmpty ? l10n.validationRequired : null;
    });
    final formOk = _formKey.currentState?.validate() ?? false;
    if (_phoneError != null || !formOk) return;
    FocusScope.of(context).unfocus();
    context.read<LoginCubit>().submit(
          phoneNumber: _phone,
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar: AppBar(actions: const [LanguageToggleButton(), SizedBox(width: 8)]),
      body: SafeArea(
        child: BlocConsumer<LoginCubit, LoginState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == FormStatus.success && state.user != null) {
              context.read<AuthBloc>().add(AuthLoggedIn(state.user!));
            }
          },
          builder: (context, state) {
            final phoneError = _phoneError ?? state.fieldErrors['phone_number'];
            return Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(24, 8, 24, 32),
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 460),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const SizedBox(height: 8),
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: AppLogo(size: 44),
                        ),
                        const SizedBox(height: 28),
                        Text(l10n.loginTitle, style: textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(l10n.loginSubtitle, style: textTheme.bodyMedium?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 24),

                        if (state.status == FormStatus.failure && state.errorMessage != null)
                          ErrorBanner(message: state.errorMessage!),

                        PhoneField(
                          label: l10n.phoneLabel,
                          hint: l10n.phoneHint,
                          enabled: !state.isSubmitting,
                          errorText: phoneError,
                          onChanged: (value) {
                            _phone = value;
                            if (_phoneError != null) setState(() => _phoneError = null);
                          },
                        ),
                        const SizedBox(height: 16),

                        TextFormField(
                          controller: _passwordController,
                          enabled: !state.isSubmitting,
                          obscureText: _obscure,
                          textInputAction: TextInputAction.done,
                          onFieldSubmitted: (_) => _submit(),
                          decoration: InputDecoration(
                            labelText: l10n.passwordLabel,
                            errorText: state.fieldErrors['password'],
                            suffixIcon: IconButton(
                              onPressed: () => setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (value) =>
                              (value == null || value.isEmpty) ? l10n.validationRequired : null,
                        ),
                        const SizedBox(height: 24),

                        FilledButton(
                          onPressed: state.isSubmitting ? null : _submit,
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(strokeWidth: 2.4),
                                )
                              : Text(l10n.loginButton),
                        ),
                        const SizedBox(height: 20),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.noAccountQuestion, style: textTheme.bodyMedium),
                            TextButton(
                              onPressed: state.isSubmitting ? null : () => context.push(AppRoutes.register),
                              child: Text(l10n.signUpLink),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}