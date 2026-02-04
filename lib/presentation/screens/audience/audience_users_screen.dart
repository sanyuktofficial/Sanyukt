import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_theme.dart';
import '../../../data/repositories/audience_repository.dart';
import '../../widgets/responsive_scaffold.dart';

class AudienceUsersScreen extends StatelessWidget {
  const AudienceUsersScreen({super.key, required this.categoryId});

  static const routePath = '/audience/:categoryId';
  static const routeName = 'audience-users';

  final String categoryId;

  static String _typeFromCategoryId(String id) {
    switch (id.toLowerCase()) {
      case 'business':
        return 'business';
      case 'jobs':
      case 'job':
        return 'job';
      case 'student':
        return 'student';
      default:
        return id;
    }
  }

  @override
  Widget build(BuildContext context) {
    final type = _typeFromCategoryId(categoryId);
    final title = categoryId[0].toUpperCase() + categoryId.substring(1).toLowerCase();

    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(title),
      ),
      body: FutureBuilder(
        future: context.read<AudienceRepository>().getUsersByCategory(type, ''),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.error_outline, size: 48, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      snapshot.error.toString(),
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }
          final users = snapshot.data ?? [];
          if (users.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No users in this category yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ],
                ),
              ),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            separatorBuilder: (_, __) => const Divider(height: 1),
            itemBuilder: (context, index) {
              final user = users[index];
              final subtitle = [
                if (user.designation != null) user.designation,
                if (user.companyName != null) user.companyName,
                if (user.city != null) user.city,
              ].where((e) => e != null && e.isNotEmpty).join(' · ');
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: appPrimary.withOpacity(0.1),
                  backgroundImage: user.photoUrl != null && user.photoUrl!.isNotEmpty
                      ? NetworkImage(user.photoUrl!)
                      : null,
                  child: user.photoUrl == null || user.photoUrl!.isEmpty
                      ? Icon(Icons.person_outline, color: appPrimary)
                      : null,
                ),
                title: Text(user.name),
                subtitle: Text(subtitle),
                trailing: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '${user.profileCompletion.toStringAsFixed(0)}%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: user.profileCompletion >= 75 ? appPrimary : Colors.orange,
                      ),
                    ),
                    const SizedBox(height: 4),
                    SizedBox(
                      width: 48,
                      height: 4,
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(2),
                        child: LinearProgressIndicator(
                          value: user.profileCompletion / 100,
                          backgroundColor: Colors.grey.shade300,
                          valueColor: AlwaysStoppedAnimation<Color>(
                            user.profileCompletion >= 75 ? appPrimary : Colors.orange,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                onTap: () => context.push('/user/${user.id}'),
              );
            },
          );
        },
      ),
    );
  }
}
