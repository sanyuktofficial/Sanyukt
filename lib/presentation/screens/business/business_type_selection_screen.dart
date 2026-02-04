import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../widgets/responsive_scaffold.dart';
import 'industry_categories_screen.dart';

class BusinessTypeSelectionScreen extends StatelessWidget {
  const BusinessTypeSelectionScreen({super.key});

  static const routePath = '/business';
  static const routeName = 'business-type';

  static const _options = [
    _Option(
      id: 'business',
      label: 'Business',
      subtitle: 'Connect with business owners',
      icon: Icons.store_rounded,
      gradient: [Color(0xFF1B5E20), Color(0xFF4CAF50)],
    ),
    _Option(
      id: 'job',
      label: 'Job',
      subtitle: 'Find job opportunities',
      icon: Icons.work_rounded,
      gradient: [Color(0xFF0D47A1), Color(0xFF42A5F5)],
    ),
    _Option(
      id: 'student',
      label: 'Student',
      subtitle: 'Connect with students',
      icon: Icons.school_rounded,
      gradient: [Color(0xFF4A148C), Color(0xFFAB47BC)],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Business & Career'),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 400;
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What are you looking for?',
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade800,
                      ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Pick one to browse by industry',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
                const SizedBox(height: 24),
                if (isNarrow)
                  ..._options.asMap().entries.map((e) => Padding(
                        padding: EdgeInsets.only(bottom: e.key < _options.length - 1 ? 16 : 0),
                        child: _GradientTile(
                          option: e.value,
                          onTap: () => _navigate(context, e.value.id),
                        ),
                      ))
                else
                  GridView.count(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 0.75,
                    children: _options
                        .map((opt) => _GradientTile(
                              option: opt,
                              onTap: () => _navigate(context, opt.id),
                            ))
                        .toList(),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }

  void _navigate(BuildContext context, String type) {
    context.pushNamed(
      IndustryCategoriesScreen.routeName,
      pathParameters: {'type': type},
    );
  }
}

class _Option {
  const _Option({
    required this.id,
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.gradient,
  });
  final String id;
  final String label;
  final String subtitle;
  final IconData icon;
  final List<Color> gradient;
}

class _GradientTile extends StatelessWidget {
  const _GradientTile({required this.option, required this.onTap});

  final _Option option;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: option.gradient,
                stops: const [0.0, 1.0],
              ),
              boxShadow: [
                BoxShadow(
                  color: option.gradient.first.withOpacity(0.35),
                  blurRadius: 12,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.25),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    option.icon,
                    size: 40,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  option.label,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 0.5,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  option.subtitle,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.white.withOpacity(0.9),
                  ),
                ),
                // const SizedBox(height: 8),
                // Icon(
                //   Icons.arrow_forward_rounded,
                //   size: 20,
                //   color: Colors.white.withOpacity(0.9),
                // ),
              ],
            ),
          ),
        ),
    );
  }
}
