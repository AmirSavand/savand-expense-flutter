import 'package:expense/features/auth/presentation/providers/auth_provider.dart';
import 'package:expense/shared/widgets/input/input_email.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

/// Login screen where the user enters their email to receive an OTP.
class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();

  @override
  void initState() {
    super.initState();

    // Listen to auth state and go to OTP page or show error.
    ref.listenManual(authProvider, (_, next) {
      if (next case AuthOtpSent()) {
        context.pushNamed('otp', extra: next.email);
        return;
      }
      if (next case AuthError()) {
        ScaffoldMessenger.of(context)
          ..clearSnackBars()
          ..showSnackBar(SnackBar(content: Text(next.message)));
      }
    });
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    await ref
        .read(authProvider.notifier)
        .requestOtp(_emailController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final isLoading = authState is AuthLoading;
    final theme = Theme.of(context);

    return Scaffold(
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
                      'Welcome Back',
                      style: theme.textTheme.headlineMedium,
                    ),
                  ),
                  // Subtitle
                  Center(
                    child: Text(
                      'Enter your email to login to Savand Expense.',
                      style: TextStyle(color: theme.hintColor),
                    ),
                  ),
                  // Spacer
                  const SizedBox(height: 16),
                  // Email input
                  InputEmail(
                    controller: _emailController,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _submit(),
                  ),
                  // Spacer
                  const SizedBox(height: 16),
                  // Submit button
                  FilledButton(
                    onPressed: isLoading ? null : _submit,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      child: const Text('Send OTP'),
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
