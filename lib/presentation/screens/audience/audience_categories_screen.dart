import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_theme.dart';
import '../../widgets/responsive_scaffold.dart';
import 'audience_users_screen.dart';

class AudienceCategoriesScreen extends StatelessWidget {
  const AudienceCategoriesScreen({super.key});

  static const routePath = '/audience';
  static const routeName = 'audience';

  static const _dummyCategories = [
    _AudienceCategory('business', 'Business', Icons.store_mall_directory),
    _AudienceCategory('jobs', 'Jobs', Icons.work_outline),
    _AudienceCategory('medical', 'Medical', Icons.local_hospital_outlined),
    _AudienceCategory('spiritual', 'Spiritual', Icons.self_improvement),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Audience'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.builder(
          itemCount: _dummyCategories.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.2,
          ),
          itemBuilder: (context, index) {
            final cat = _dummyCategories[index];
            final colors = [
              jainYellow,
              jainRed,
              jainGreen,
              jainBlue,
            ];
            final bg = colors[index % colors.length].withOpacity(0.15);

            return InkWell(
              onTap: () {
                context.goNamed(
                  AudienceUsersScreen.routeName,
                  pathParameters: {'categoryId': cat.id},
                );
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: bg,
                  borderRadius: BorderRadius.circular(16),
                ),
                padding: const EdgeInsets.all(16),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(cat.icon, size: 40, color: appPrimary),
                    const SizedBox(height: 12),
                    Text(
                      cat.name,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _AudienceCategory {
  const _AudienceCategory(this.id, this.name, this.icon);
  final String id;
  final String name;
  final IconData icon;
}

