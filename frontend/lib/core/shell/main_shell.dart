import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_theme.dart';

/// Shell persistente com a barra de navegação inferior.
/// O [child] é trocado pelo go_router ao navegar entre abas.
class MainShell extends StatelessWidget {
  final Widget child;

  const MainShell({super.key, required this.child});

  static const _tabs = [
    _NavTab(label: 'Início', icon: Icons.home_rounded, path: '/inicio'),
    _NavTab(label: 'Categorias', icon: Icons.grid_view_rounded, path: '/categorias'),
    _NavTab(label: 'Promoções', icon: Icons.local_offer_rounded, path: '/promocoes'),
    _NavTab(label: 'Perfil', icon: Icons.person_rounded, path: '/perfil'),
  ];

  int _currentIndex(BuildContext context) {
    final location = GoRouterState.of(context).matchedLocation;
    for (var i = 0; i < _tabs.length; i++) {
      if (location.startsWith(_tabs[i].path)) return i;
    }
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final currentIndex = _currentIndex(context);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          if (index != currentIndex) {
            context.go(_tabs[index].path);
          }
        },
        animationDuration: const Duration(milliseconds: 300),
        destinations: _tabs
            .map(
              (tab) => NavigationDestination(
                icon: Icon(tab.icon),
                label: tab.label,
              ),
            )
            .toList(),
      ),
    );
  }
}

class _NavTab {
  final String label;
  final IconData icon;
  final String path;

  const _NavTab({
    required this.label,
    required this.icon,
    required this.path,
  });
}
