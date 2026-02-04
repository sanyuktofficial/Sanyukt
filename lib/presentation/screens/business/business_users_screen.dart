import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_theme.dart';
import '../../../data/repositories/audience_repository.dart';
import '../../widgets/responsive_scaffold.dart';

class BusinessUsersScreen extends StatelessWidget {
  const BusinessUsersScreen({
    super.key,
    required this.type,
    required this.category,
  });

  static const routePath = '/business/:type/users';
  static const routeName = 'business-users';

  final String type;
  final String category;

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(category),
      ),
      body: FutureBuilder(
        future: context.read<AudienceRepository>().getUsersByCategory(type, category),
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
          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final user = users[index];
              return _UserCard(
                name: user.name,
                designation: user.designation,
                companyName: user.companyName,
                city: user.city,
                photoUrl: user.photoUrl,
                onTap: () => context.push('/user/${user.id}'),
              );
            },
          );
        },
      ),
    );
  }
}

class _UserCard extends StatelessWidget {
  const _UserCard({
    required this.name,
    required this.designation,
    required this.companyName,
    required this.city,
    required this.photoUrl,
    required this.onTap,
  });

  final String name;
  final String? designation;
  final String? companyName;
  final String? city;
  final String? photoUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final subtitle = [
      if (designation != null && designation!.isNotEmpty) designation,
      if (companyName != null && companyName!.isNotEmpty) companyName,
      if (city != null && city!.isNotEmpty) city,
    ].join(' · ');

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.white,
        elevation: 1,
        borderRadius: BorderRadius.circular(14),
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 28,
                  backgroundColor: appPrimary.withOpacity(0.1),
                  backgroundImage: photoUrl != null && photoUrl!.isNotEmpty
                      ? NetworkImage(photoUrl!)
                      : null,
                  child: photoUrl == null || photoUrl!.isEmpty
                      ? Icon(Icons.person_rounded, size: 28, color: appPrimary)
                      : null,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.black87,
                        ),
                      ),
                      if (subtitle.isNotEmpty) ...[
                        const SizedBox(height: 4),
                        Text(
                          subtitle,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey.shade600,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ],
                  ),
                ),
                Icon(Icons.arrow_forward_ios, size: 14, color: Colors.grey.shade400),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
