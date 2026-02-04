import 'package:flutter/material.dart';

class ResponsiveScaffold extends StatelessWidget {
  const ResponsiveScaffold({
    super.key,
    required this.body,
    this.appBar,
    this.drawer,
    this.fab,
  });

  final Widget body;
  final PreferredSizeWidget? appBar;
  final Widget? drawer;
  final Widget? fab;

  bool _isWide(BuildContext context) =>
      MediaQuery.of(context).size.width >= 800;

  @override
  Widget build(BuildContext context) {
    final isWide = _isWide(context);

    if (!isWide) {
      return Scaffold(
        appBar: appBar,
        drawer: drawer != null ? Drawer(child: drawer) : null,
        body: body,
        floatingActionButton: fab,
      );
    }

    return Scaffold(
      appBar: appBar,
      body: Row(
        children: [
          if (drawer != null)
            SizedBox(
              width: 260,
              child: Drawer(child: drawer),
            ),
          const VerticalDivider(width: 1),
          Expanded(child: body),
        ],
      ),
      floatingActionButton: fab,
    );
  }
}

