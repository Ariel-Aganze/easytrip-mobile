import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/features/auth/presentation/cubit/register_cubit.dart';
import 'package:easytrip/features/auth/presentation/widgets/phone_field.dart';
import 'package:easytrip/shared/widgets/app_logo.dart';
import 'package:easytrip/shared/widgets/error_banner.dart';
import 'package:easytrip/shared/widgets/language_toggle_button.dart';

class RegisterPage extends StatelessWidget {
  const RegisterPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RegisterCubit>(
      create: (_) => sl<RegisterCubit>(),
      child: const _RegisterView(),
    );
  }
}

class _RegisterView extends StatefulWidget {
  const _RegisterView();

  @override
  State<_RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<_RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  String _phone = '';
  String? _phoneError;
  bool _obscure = true;

  static final _emailRegex = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
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
    context.read<RegisterCubit>().submit(
          fullName: _nameController.text.trim(),
          phoneNumber: _phone,
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final textTheme = Theme.of(context).textTheme;

    return Scaffold(
      appBar:
          AppBar(actions: const [LanguageToggleButton(), SizedBox(width: 8)]),
      body: SafeArea(
        child: BlocConsumer<RegisterCubit, RegisterState>(
          listenWhen: (prev, curr) => prev.status != curr.status,
          listener: (context, state) {
            if (state.status == RegisterStatus.success && state.user != null) {
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
                        Text(l10n.registerTitle,
                            style: textTheme.headlineSmall
                                ?.copyWith(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 6),
                        Text(l10n.registerSubtitle,
                            style: textTheme.bodyMedium
                                ?.copyWith(color: scheme.onSurfaceVariant)),
                        const SizedBox(height: 24),
                        if (state.status == RegisterStatus.failure &&
                            state.errorMessage != null)
                          ErrorBanner(message: state.errorMessage!),
                        TextFormField(
                          controller: _nameController,
                          enabled: !state.isSubmitting,
                          textInputAction: TextInputAction.next,
                          textCapitalization: TextCapitalization.words,
                          decoration: InputDecoration(
                            labelText: l10n.fullNameLabel,
                            hintText: l10n.fullNameHint,
                            errorText: state.fieldErrors['full_name'],
                          ),
                          validator: (value) =>
                              (value == null || value.trim().isEmpty)
                                  ? l10n.validationRequired
                                  : null,
                        ),
                        const SizedBox(height: 16),
                        PhoneField(
                          label: l10n.phoneLabel,
                          hint: l10n.phoneHint,
                          enabled: !state.isSubmitting,
                          errorText: phoneError,
                          onChanged: (value) {
                            _phone = value;
                            if (_phoneError != null) {
                              setState(() => _phoneError = null);
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _emailController,
                          enabled: !state.isSubmitting,
                          keyboardType: TextInputType.emailAddress,
                          textInputAction: TextInputAction.next,
                          decoration: InputDecoration(
                            labelText: l10n.emailLabel,
                            hintText: l10n.emailHint,
                            errorText: state.fieldErrors['email'],
                          ),
                          validator: (value) {
                            final v = value?.trim() ?? '';
                            if (v.isEmpty) return null; // optional
                            return _emailRegex.hasMatch(v)
                                ? null
                                : l10n.validationInvalidEmail;
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
                            labelText: l10n.createPasswordLabel,
                            errorText: state.fieldErrors['password'],
                            suffixIcon: IconButton(
                              onPressed: () =>
                                  setState(() => _obscure = !_obscure),
                              icon: Icon(_obscure
                                  ? Icons.visibility_outlined
                                  : Icons.visibility_off_outlined),
                            ),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return l10n.validationRequired;
                            }
                            if (value.length < 8) {
                              return l10n.validationPasswordTooShort;
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        FilledButton(
                          onPressed: state.isSubmitting ? null : _submit,
                          child: state.isSubmitting
                              ? const SizedBox(
                                  height: 22,
                                  width: 22,
                                  child: CircularProgressIndicator(
                                      strokeWidth: 2.4),
                                )
                              : Text(l10n.registerButton),
                        ),
                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(l10n.haveAccountQuestion,
                                style: textTheme.bodyMedium),
                            TextButton(
                              onPressed: state.isSubmitting
                                  ? null
                                  : () {
                                      if (context.canPop()) {
                                        context.pop();
                                      } else {
                                        context.go(AppRoutes.login);
                                      }
                                    },
                              child: Text(l10n.loginLink),
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
