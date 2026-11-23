import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:easytrip/core/di/injector.dart';
import 'package:easytrip/core/router/app_routes.dart';
import 'package:easytrip/core/utils/result.dart';
import 'package:easytrip/features/account/data/account_repository.dart';
import 'package:easytrip/features/auth/presentation/widgets/phone_field.dart';
import 'package:easytrip/l10n/app_localizations.dart';
import 'package:easytrip/shared/widgets/error_banner.dart';

/// Password reset by SMS code: phone → code + new password → done.
class ForgotPasswordPage extends StatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

enum _Step { phone, code, done }

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  _Step _step = _Step.phone;
  String _phone = '';
  final _code = TextEditingController();
  final _password = TextEditingController();
  bool _busy = false;
  String? _error;
  Map<String, String> _fieldErrors = const {};

  @override
  void dispose() {
    _code.dispose();
    _password.dispose();
    super.dispose();
  }

  Future<void> _run(Future<Result<void>> Function() action, _Step next) async {
    setState(() {
      _busy = true;
      _error = null;
      _fieldErrors = const {};
    });
    final result = await action();
    if (!mounted) return;
    setState(() {
      _busy = false;
      switch (result) {
        case Ok():
          _step = next;
        case Err(failure: final f):
          _fieldErrors = f.fieldErrors;
          _error = f.fieldErrors.isEmpty ? f.message : null;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final repo = sl<AccountRepository>();
    return Scaffold(
      appBar: AppBar(title: Text(l10n.forgotTitle)),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            if (_error != null) ErrorBanner(message: _error!),
            ...switch (_step) {
              _Step.phone => [
                  Text(l10n.forgotIntro),
                  const SizedBox(height: 16),
                  PhoneField(
                      onChanged: (v) => setState(() => _phone = v),
                      label: l10n.phoneLabel),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy || _phone.isEmpty
                        ? null
                        : () => _run(() => repo.requestPasswordReset(_phone),
                            _Step.code),
                    child: Text(l10n.sendCode),
                  ),
                ],
              _Step.code => [
                  Text(l10n.resetCodeSent),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _code,
                    keyboardType: TextInputType.number,
                    maxLength: 6,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    decoration: InputDecoration(
                        labelText: l10n.smsCodeLabel,
                        errorText: _fieldErrors['code']),
                  ),
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                        labelText: l10n.newPassword,
                        errorText: _fieldErrors['new_password']),
                  ),
                  const SizedBox(height: 16),
                  FilledButton(
                    onPressed: _busy
                        ? null
                        : () => _run(
                              () => repo.confirmPasswordReset(
                                  phone: _phone,
                                  code: _code.text.trim(),
                                  newPassword: _password.text),
                              _Step.done,
                            ),
                    child: Text(l10n.setNewPassword),
                  ),
                ],
              _Step.done => [
                  Text(l10n.resetDone),
                  const SizedBox(height: 16),
                  FilledButton(
                      onPressed: () => context.go(AppRoutes.login),
                      child: Text(l10n.loginButton)),
                ],
            },
          ],
        ),
      ),
    );
  }
}
