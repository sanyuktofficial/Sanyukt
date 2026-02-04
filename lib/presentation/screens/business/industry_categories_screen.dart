import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../core/app_theme.dart';
import '../../../data/repositories/audience_repository.dart';
import '../../widgets/responsive_scaffold.dart';

class IndustryCategoriesScreen extends StatelessWidget {
  const IndustryCategoriesScreen({super.key, required this.type});

  static const routePath = '/business/:type';
  static const routeName = 'industry-categories';

  final String type;

  String get _title {
    switch (type) {
      case 'business':
        return 'Business categories';
      case 'job':
        return 'Job categories';
      case 'student':
        return 'Student categories';
      default:
        return 'Categories';
    }
  }

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: Text(_title),
      ),
      body: FutureBuilder<List<AudienceCategory>>(
        future: context.read<AudienceRepository>().getCategories(type),
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
          final categories = snapshot.data ?? [];
          if (categories.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.folder_off_outlined, size: 64, color: Colors.grey.shade400),
                    const SizedBox(height: 16),
                    Text(
                      'No categories yet',
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Categories will appear when users add their ${type == 'student' ? 'field of study' : 'industry'} in their profile.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            );
          }
          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.1,
            ),
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final cat = categories[index];
              final colors = [
                appPrimary,
                const Color(0xFF2E7D32),
                const Color(0xFF1565C0),
                const Color(0xFF6A1B9A),
              ];
              final color = colors[index % colors.length];
              return Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    context.push(
                      '/business/$type/users?category=${Uri.encodeComponent(cat.name)}',
                    );
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: color.withOpacity(0.3)),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          type == 'student' ? Icons.school_outlined : Icons.business_center_outlined,
                          size: 36,
                          color: color,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          cat.name,
                          textAlign: TextAlign.center,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: color,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
