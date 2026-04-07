import 'package:expense/features/auth/presentation/providers/auth_provider.dart';
import 'package:expense/shared/widgets/input/input_number.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Screen where the user enters the 6-digit OTP code sent to their email.
class OtpScreen extends ConsumerStatefulWidget {
  /// The email address the OTP was sent to, passed from [LoginScreen].
  final String email;

  const OtpScreen({super.key, required this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  /// Controls the OTP code input field.
  final _codeController = TextEditingController();

  /// Key used to validate the OTP form before submission.
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    // Listen to auth and go to start or show error.
    ref.listenManual(authProvider, (prev, next) {
      if (next is AuthAuthenticated) {
        context.goNamed('start');
      }
      if (next is AuthError) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  /// Validates the form and submits the OTP code for verification.
  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    await ref
        .read(authProvider.notifier)
        .verifyOtp(widget.email, _codeController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(32),
            child: Form(
              key: _formKey,
              child: Column(
                spacing: 8,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Title
                  Center(
                    child: Text(
                      'OTP Code',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  // Subtitle
                  Center(
                    child: Text(
                      'Enter the 6-digit code sent to: ${widget.email}',
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
                  // Spacer
                  const SizedBox(height: 16),
                  // OTP field
                  InputNumber(
                    label: 'Code',
                    controller: _codeController,
                    maxLength: 6,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                    validator: (value) {
                      if (value == null || value.trim().length != 6) {
                        return 'Please enter the 6-digit code.';
                      }
                      return null;
                    },
                  ),
                  // Spacer
                  const SizedBox(height: 16),
                  // Submit button
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: const Text('Verify'),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
