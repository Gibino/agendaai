import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/auth/screens/tela_login.dart';
import '../../features/auth/screens/tela_cadastro.dart';
import '../../features/auth/screens/tela_otp.dart';
import '../../features/home/screens/tela_principal.dart';
import '../../features/categories/screens/tela_categorias.dart';
import '../../features/categories/screens/tela_detalhe_categoria.dart';
import '../../features/promotions/screens/tela_promocoes.dart';
import '../../features/settings/screens/tela_configuracoes.dart';
import '../shell/main_shell.dart';

final appRouterProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authStateProvider);

  return GoRouter(
    initialLocation: '/inicio',
    redirect: (context, state) {
      final isAuthenticated = authState.valueOrNull != null;
      final isAuthRoute = state.matchedLocation.startsWith('/login') ||
          state.matchedLocation.startsWith('/cadastro') ||
          state.matchedLocation.startsWith('/otp');

      if (!isAuthenticated && !isAuthRoute) return '/login';
      if (isAuthenticated && isAuthRoute) return '/inicio';
      return null;
    },
    routes: [
      // ── Autenticação ────────────────────────────────────────────────────
      GoRoute(path: '/login', builder: (_, __) => const TelaLogin()),
      GoRoute(path: '/cadastro', builder: (_, __) => const TelaCadastro()),
      GoRoute(path: '/otp', builder: (_, __) => const TelaOtp()),

      // ── Shell com barra de navegação inferior ────────────────────────────
      ShellRoute(
        builder: (context, state, child) => MainShell(child: child),
        routes: [
          GoRoute(
            path: '/inicio',
            builder: (_, __) => const TelaPrincipal(),
          ),
          GoRoute(
            path: '/categorias',
            builder: (_, __) => const TelaCategorias(),
            routes: [
              GoRoute(
                path: ':id',
                builder: (_, state) => TelaDetalheCategoria(
                  categoriaId: state.pathParameters['id']!,
                ),
              ),
            ],
          ),
          GoRoute(
            path: '/promocoes',
            builder: (_, __) => const TelaPromocoes(),
          ),
          GoRoute(
            path: '/perfil',
            builder: (_, __) => const TelaConfiguracoes(),
          ),
        ],
      ),
    ],
  );
});
