import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class _NavItem {
  final String route;
  final IconData icon;
  final String label;

  const _NavItem({
    required this.route,
    required this.icon,
    required this.label,
  });
}

class AppAnonymousScaffold extends StatelessWidget {
  final Widget child;

  static const _links = [
    _NavItem(route: '/login', icon: Icons.login, label: 'Login'),
    _NavItem(
      route: '/register',
      icon: Icons.app_registration,
      label: 'Register',
    ),
  ];

  const AppAnonymousScaffold({super.key, required this.child});

  int _resolveIndex(BuildContext context) {
    final path = GoRouterState.of(context).uri.toString();
    final index = _links.indexWhere((item) => path.contains(item.route));
    return index == -1 ? 0 : index;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _resolveIndex(context),
        onDestinationSelected: (index) => context.go(_links[index].route),
        destinations: _links.map((item) {
          return NavigationDestination(
            icon: Icon(item.icon),
            label: item.label,
          );
        }).toList(),
      ),
    );
  }
}
