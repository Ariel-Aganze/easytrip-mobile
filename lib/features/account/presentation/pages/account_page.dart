import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/account/data/account_repository.dart';
import 'package:easytrip/features/auth/domain/entities/auth_user.dart';
import 'package:easytrip/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/shared/widgets/error_banner.dart';

/// Account tab: profile, phone verification, password, logout (SRS §29).
class AccountPage extends StatelessWidget {
  const AccountPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final state = context.watch<AuthBloc>().state;
    final user = state is AuthAuthenticated ? state.user : null;
    if (user == null) return const SizedBox.shrink();

    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
      children: [
        Text(l10n.accountTitle,
            style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(fontWeight: FontWeight.w700)),
        const SizedBox(height: 16),
        _ProfileCard(key: ValueKey('profile-${user.id}'), user: user),
        const SizedBox(height: 16),
        _PhoneCard(user: user),
        const SizedBox(height: 16),
        const _PasswordCard(),
        const SizedBox(height: 24),
        OutlinedButton.icon(
          onPressed: () => context.read<AuthBloc>().add(const AuthLoggedOut()),
          icon: const Icon(Icons.logout),
          label: Text(l10n.logout),
        ),
      ],
    );
  }
}

/// Shared busy/error/success handling for the account cards.
mixin _Action<T extends StatefulWidget> on State<T> {
  bool busy = false;
  String? error;
  String? success;
  Map<String, String> fieldErrors = const {};

  Future<void> run<R>(Future<Result<R>> Function() action,
      {required String done, void Function(R)? onOk}) async {
    setState(() {
      busy = true;
      error = null;
      success = null;
      fieldErrors = const {};
    });
    final result = await action();
    if (!mounted) return;
    setState(() {
      busy = false;
      switch (result) {
        case Ok(value: final v):
          success = done;
          onOk?.call(v);
        case Err(failure: final f):
          fieldErrors = f.fieldErrors;
          error = f.fieldErrors.isEmpty ? f.message : null;
      }
    });
  }

  List<Widget> feedback(BuildContext context) => [
        if (error != null) ErrorBanner(message: error!),
        if (success != null)
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(success!,
                style: TextStyle(color: Theme.of(context).colorScheme.primary)),
          ),
      ];
}

class _Section extends StatelessWidget {
  const _Section({required this.title, required this.children, this.trailing});
  final String title;
  final List<Widget> children;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(children: [
              Expanded(
                child: Text(title,
                    style: Theme.of(context)
                        .textTheme
                        .titleMedium
                        ?.copyWith(fontWeight: FontWeight.w700)),
              ),
              if (trailing != null) trailing!,
            ]),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }
}

class _ProfileCard extends StatefulWidget {
  const _ProfileCard({super.key, required this.user});
  final AuthUser user;
  @override
  State<_ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<_ProfileCard> with _Action {
  late final _name = TextEditingController(text: widget.user.fullName);
  late final _email = TextEditingController(text: widget.user.email ?? '');

  @override
  void dispose() {
    _name.dispose();
    _email.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Section(title: l10n.profileTitle, children: [
      ...feedback(context),
      TextField(
        key: const Key('account-name'),
        controller: _name,
        decoration: InputDecoration(
            labelText: l10n.fullNameLabel, errorText: fieldErrors['full_name']),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _email,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
            labelText: l10n.emailLabel, errorText: fieldErrors['email']),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: busy
            ? null
            : () => run(
                  () => sl<AccountRepository>().updateProfile(
                      fullName: _name.text.trim(), email: _email.text.trim()),
                  done: l10n.profileSaved,
                  onOk: (user) =>
                      context.read<AuthBloc>().add(AuthLoggedIn(user)),
                ),
        child: Text(l10n.saveAction),
      ),
    ]);
  }
}

class _PhoneCard extends StatefulWidget {
  const _PhoneCard({required this.user});
  final AuthUser user;
  @override
  State<_PhoneCard> createState() => _PhoneCardState();
}

class _PhoneCardState extends State<_PhoneCard> with _Action {
  final _code = TextEditingController();
  bool _sent = false;

  @override
  void dispose() {
    _code.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final scheme = Theme.of(context).colorScheme;
    final verified = widget.user.phoneVerified;
    return _Section(
      title: l10n.phoneLabel,
      trailing: Chip(
        label: Text(verified ? l10n.phoneVerified : l10n.phoneNotVerified),
        backgroundColor:
            verified ? scheme.primaryContainer : scheme.tertiaryContainer,
        side: BorderSide.none,
      ),
      children: [
        Text(widget.user.phoneNumber,
            style: Theme.of(context).textTheme.bodyLarge),
        if (!verified) ...[
          const SizedBox(height: 8),
          Text(l10n.phoneVerifyHint,
              style: TextStyle(color: scheme.onSurfaceVariant)),
          const SizedBox(height: 12),
          ...feedback(context),
          if (_sent) ...[
            TextField(
              key: const Key('phone-code'),
              controller: _code,
              keyboardType: TextInputType.number,
              maxLength: 6,
              autofillHints: const [AutofillHints.oneTimeCode],
              decoration: InputDecoration(
                  labelText: l10n.smsCodeLabel, errorText: fieldErrors['code']),
            ),
            FilledButton(
              onPressed: busy
                  ? null
                  : () => run(
                        () => sl<AccountRepository>()
                            .confirmPhoneCode(_code.text.trim()),
                        done: l10n.phoneVerifiedDone,
                        onOk: (user) =>
                            context.read<AuthBloc>().add(AuthLoggedIn(user)),
                      ),
              child: Text(l10n.verifyAction),
            ),
            const SizedBox(height: 8),
          ],
          OutlinedButton(
            onPressed: busy
                ? null
                : () => run(
                      () => sl<AccountRepository>().requestPhoneCode(),
                      done: l10n.codeSent,
                      onOk: (_) => _sent = true,
                    ),
            child: Text(_sent ? l10n.resendCode : l10n.sendCode),
          ),
        ],
      ],
    );
  }
}

class _PasswordCard extends StatefulWidget {
  const _PasswordCard();
  @override
  State<_PasswordCard> createState() => _PasswordCardState();
}

class _PasswordCardState extends State<_PasswordCard> with _Action {
  final _current = TextEditingController();
  final _next = TextEditingController();

  @override
  void dispose() {
    _current.dispose();
    _next.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return _Section(title: l10n.passwordLabel, children: [
      ...feedback(context),
      TextField(
        controller: _current,
        obscureText: true,
        decoration: InputDecoration(
            labelText: l10n.currentPassword,
            errorText: fieldErrors['current_password']),
      ),
      const SizedBox(height: 12),
      TextField(
        controller: _next,
        obscureText: true,
        decoration: InputDecoration(
            labelText: l10n.newPassword,
            errorText: fieldErrors['new_password']),
      ),
      const SizedBox(height: 12),
      FilledButton(
        onPressed: busy
            ? null
            : () => run(
                  () => sl<AccountRepository>()
                      .changePassword(_current.text, _next.text),
                  done: l10n.passwordChanged,
                  onOk: (_) {
                    _current.clear();
                    _next.clear();
                  },
                ),
        child: Text(l10n.changePassword),
      ),
    ]);
  }
}
