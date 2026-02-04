import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_theme.dart';
import '../../logic/auth/auth_cubit.dart';
import '../widgets/responsive_scaffold.dart';
import 'audience/audience_categories_screen.dart';
import 'profile/profile_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const routePath = '/';
  static const routeName = 'home';

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;

    final String greetingName;
    switch (authState.status) {
      case AuthStatus.authenticated:
        greetingName = authState.userName ?? 'Member';
        break;
      case AuthStatus.guest:
        greetingName = 'Guest';
        break;
      case AuthStatus.unauthenticated:
      case AuthStatus.unknown:
        greetingName = 'Friend';
        break;
    }

    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Sanyukt'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                GestureDetector(
                  onTap: () => context.goNamed(ProfileScreen.routeName),
                  child: CircleAvatar(
                    radius: 28,
                    backgroundImage: authState.photoUrl != null
                        ? NetworkImage(authState.photoUrl!)
                        : null,
                    child: authState.photoUrl == null
                        ? const Icon(Icons.person_outline, size: 30)
                        : null,
                  ),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Namaste, $greetingName',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Welcome to the Jain community network',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: const [
                _StatCard(
                  label: 'Total Audience',
                  value: '24',
                ),
                SizedBox(width: 12),
                _StatCard(
                  label: 'Active Members',
                  value: '18',
                ),
              ],
            ),
            const SizedBox(height: 24),
            Text(
              'Quick access',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              children: const [
                _QuickChip(
                  icon: Icons.people_outline,
                  label: 'Audience',
                  target: _QuickTarget.audience,
                ),
                _QuickChip(
                  icon: Icons.store_mall_directory,
                  label: 'Business',
                  target: _QuickTarget.business,
                ),
                _QuickChip(
                  icon: Icons.work_outline,
                  label: 'Jobs',
                  target: _QuickTarget.jobs,
                ),
                _QuickChip(
                  icon: Icons.favorite_outline,
                  label: 'Matrimony',
                  target: _QuickTarget.matrimony,
                ),
              ],
            ),
          ],
        ),
      ),
      fab: FloatingActionButton.extended(
        onPressed: () {
          context.goNamed(AudienceCategoriesScreen.routeName);
        },
        icon: const Icon(Icons.people_outline),
        label: const Text('Explore audience'),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

enum _QuickTarget { audience, business, jobs, matrimony }

class _QuickChip extends StatelessWidget {
  const _QuickChip({
    required this.icon,
    required this.label,
    required this.target,
  });

  final IconData icon;
  final String label;
  final _QuickTarget target;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 18),
      label: Text(label),
      onPressed: () {
        switch (target) {
          case _QuickTarget.audience:
            context.goNamed(AudienceCategoriesScreen.routeName);
            break;
          case _QuickTarget.business:
          case _QuickTarget.jobs:
          case _QuickTarget.matrimony:
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                backgroundColor: appPrimary,
                content: Text('Module coming soon'),
              ),
            );
            break;
        }
      },
    );
  }
}

