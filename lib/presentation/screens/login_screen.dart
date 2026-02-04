import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../logic/auth/auth_cubit.dart';
import '../../services/notification_service.dart';
import 'home_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  static const routePath = '/login';
  static const routeName = 'login';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 400),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const FlutterLogo(size: 88),
                  const SizedBox(height: 16),
                  const Text(
                    'Sanyukt Jain Community',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 32),
                  BlocConsumer<AuthCubit, AuthState>(
                    listenWhen: (prev, curr) =>
                        prev.status != curr.status ||
                        prev.errorMessage != curr.errorMessage,
                    listener: (context, state) {
                      if (state.errorMessage != null) {
                        NotificationService.showError(state.errorMessage!);
                      }
                      if (state.status == AuthStatus.authenticated &&
                          context.mounted) {
                        context.goNamed(HomeScreen.routeName);
                      }
                    },
                    builder: (context, state) {
                      final isLoading = state.isLoading;
                      return ElevatedButton.icon(
                        icon: isLoading
                            ? const SizedBox(
                                width: 20,
                                height: 20,
                                child: CircularProgressIndicator(
                                  strokeWidth: 2,
                                  color: Colors.white,
                                ),
                              )
                            : const Icon(Icons.login),
                        label: Text(
                          isLoading ? 'Signing in…' : 'Continue with Google',
                        ),
                        onPressed: isLoading
                            ? null
                            : () async {
                                await context
                                    .read<AuthCubit>()
                                    .signInWithGoogle();
                              },
                      );
                    },
                  ),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () async {
                      // Skip login: mark as guest and navigate to home.
                      await context.read<AuthCubit>().markGuest();
                      if (context.mounted) {
                        context.goNamed(HomeScreen.routeName);
                      }
                    },
                    child: const Text('Skip for now'),
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

