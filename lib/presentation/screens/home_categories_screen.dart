import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/app_theme.dart';
import '../widgets/responsive_scaffold.dart';
import 'audience/audience_categories_screen.dart';
import 'business/business_type_selection_screen.dart';

/// Light, relevant background images per category (Unsplash – replace with assets if needed).
const Map<String, String> _categoryBackgroundImages = {
  'AUDIENCE': 'https://images.unsplash.com/photo-1529156069898-49953e39b3ac?w=800',
  'BUSINESS': 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800',
  'JOB / WORK': 'https://images.unsplash.com/photo-1507679799987-c73779587ccf?w=800',
  'COMMUNITY': 'https://images.unsplash.com/photo-1522071820081-009f0129c71c?w=800',
  'SPIRITUAL': 'https://images.unsplash.com/photo-1544367567-0f2fcb009e0b?w=800',
  'MEDICAL': 'https://images.unsplash.com/photo-1579684385127-1ef15d508118?w=800',
  'MATRIMONY': 'https://images.unsplash.com/photo-1519741497674-611481863552?w=800',
};

class HomeCategoriesScreen extends StatelessWidget {
  const HomeCategoriesScreen({super.key});

  static const routeName = 'homeCategories';

  static const List<_CategoryData> _categories = [
    // _CategoryData(
    //   label: 'AUDIENCE',
    //   subtitle: 'Connect with people',
    //   routeName: AudienceCategoriesScreen.routeName,
    // ),
    _CategoryData(
      label: 'BUSINESS',
      subtitle: 'Grow your network',
      routeName: BusinessTypeSelectionScreen.routeName,
    ),
    _CategoryData(label: 'JOB / WORK', subtitle: 'Find opportunities'),
    _CategoryData(label: 'COMMUNITY', subtitle: 'Together we thrive'),
    _CategoryData(label: 'SPIRITUAL', subtitle: 'Inner peace'),
    _CategoryData(label: 'MEDICAL', subtitle: 'Health and wellness'),
    _CategoryData(label: 'MATRIMONY', subtitle: 'Find your match'),
  ];

  @override
  Widget build(BuildContext context) {
    return ResponsiveScaffold(
      appBar: AppBar(
        title: const Text('Categories'),
      ),
      body: ListView.builder(
        padding: EdgeInsets.zero,
        itemCount: _categories.length,
        itemBuilder: (context, index) {
          return _CategoryListTile(
            data: _categories[index],
            index: index,
          );
        },
      ),
    );
  }
}

class _CategoryData {
  const _CategoryData({
    required this.label,
    required this.subtitle,
    this.routeName,
  });
  final String label;
  final String subtitle;
  final String? routeName;
}

class _CategoryListTile extends StatefulWidget {
  const _CategoryListTile({
    required this.data,
    required this.index,
  });

  final _CategoryData data;
  final int index;

  @override
  State<_CategoryListTile> createState() => _CategoryListTileState();
}

class _CategoryListTileState extends State<_CategoryListTile>
    with SingleTickerProviderStateMixin {
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    // 1) Collide with edge  2) Travel distance and stop  3) Go to screen again (slow, very slow)
    _slideController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2400),
    );
    final isFromLeft = widget.index.isEven;
    const edgeLeft = 0.068;
    const edgeRight = -0.068;
    const stopLeft = 0.042;
    const stopRight = -0.042;
    _slideAnimation = TweenSequence<Offset>([
      // Phase 1: Approach and collide with edge
      TweenSequenceItem(
        weight: 1,
        tween: Tween<Offset>(
          begin: Offset(isFromLeft ? -1.0 : 1.0, 0),
          end: Offset(isFromLeft ? edgeLeft : edgeRight, 0),
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
      ),
      // Phase 2: Travel distance and stop (short move inward, then stop)
      TweenSequenceItem(
        weight: 0.6,
        tween: Tween<Offset>(
          begin: Offset(isFromLeft ? edgeLeft : edgeRight, 0),
          end: Offset(isFromLeft ? stopLeft : stopRight, 0),
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
      ),
      // Phase 3: Go to final position — easeOut so it moves from stop (no stall), then eases in
      TweenSequenceItem(
        weight: 2,
        tween: Tween<Offset>(
          begin: Offset(isFromLeft ? stopLeft : stopRight, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOut)),
      ),
    ]).animate(_slideController);

    Future.delayed(
      Duration(milliseconds: 80 + widget.index * 95),
      () {
        if (mounted) _slideController.forward();
      },
    );
  }

  @override
  void dispose() {
    _slideController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.width * 0.52;
    final imageUrl = _categoryBackgroundImages[widget.data.label];
    // Label on sliding side: from left → left align; from right → right align
    final isFromLeft = widget.index.isEven;
    const labelPadding = EdgeInsets.symmetric(horizontal: 20, vertical: 12);

    return SlideTransition(
      position: _slideAnimation,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.data.routeName != null
              ? () => context.pushNamed(widget.data.routeName!)
              : () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: appPrimary,
                      content: Text('${widget.data.label} coming soon'),
                    ),
                  );
                },
          child: SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              fit: StackFit.expand,
              children: [
                // Background image with fade-out + more darkness
                Container(
                  decoration: BoxDecoration(
                    image: imageUrl != null
                        ? DecorationImage(
                            image: NetworkImage(imageUrl),
                            fit: BoxFit.cover,
                            opacity: 0.48,
                          )
                        : null,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Colors.black.withOpacity(0.52),
                        Colors.black.withOpacity(0.68),
                        Colors.black.withOpacity(0.78),
                      ],
                      stops: const [0.0, 0.5, 1.0],
                    ),
                  ),
                ),
                // Label + subtitle at bottom, on sliding side (left or right)
                Align(
                  alignment: isFromLeft ? Alignment.bottomLeft : Alignment.bottomRight,
                  child: Padding(
                    padding: labelPadding,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: isFromLeft ? CrossAxisAlignment.start : CrossAxisAlignment.end,
                      children: [
                        Text(
                          widget.data.label,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 1.0,
                            shadows: [
                              Shadow(color: Colors.black45, blurRadius: 8, offset: Offset(0, 1)),
                              Shadow(color: Colors.black26, blurRadius: 4, offset: Offset(0, 0)),
                            ],
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          widget.data.subtitle,
                          style: TextStyle(
                            color: Colors.white.withOpacity(0.95),
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            shadows: const [
                              Shadow(color: Colors.black38, blurRadius: 6, offset: Offset(0, 1)),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
