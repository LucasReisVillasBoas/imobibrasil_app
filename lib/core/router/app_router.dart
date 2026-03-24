import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../features/auth/presentation/providers/auth_providers.dart';
import '../../features/auth/presentation/screens/login_screen.dart';
import '../../features/imoveis/presentation/screens/imoveis_list_screen.dart';
import '../../features/imoveis/presentation/screens/imovel_detail_screen.dart';
import '../../features/imoveis/presentation/screens/imovel_form_screen.dart';

// Rotas nomeadas
class AppRoutes {
  static const login = '/login';
  static const imoveis = '/imoveis';
  static const imovelDetail = '/imoveis/:id';
  static const imovelEdit = '/imoveis/:id/editar';
  static const imovelNew = '/imoveis/novo';

  static String detailPath(int id) => '/imoveis/$id';
  static String editPath(int id) => '/imoveis/$id/editar';
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authNotifierProvider);

  return GoRouter(
    initialLocation: AppRoutes.login,
    debugLogDiagnostics: false,
    redirect: (context, state) {
      final isAuthenticated = authState.isAuthenticated;
      final isLoginRoute = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isLoginRoute) return AppRoutes.login;
      if (isAuthenticated && isLoginRoute) return AppRoutes.imoveis;
      return null;
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: 'login',
        pageBuilder: (context, state) => _fadeTransition(
          state: state,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.imoveis,
        name: 'imoveis',
        pageBuilder: (context, state) => _slideTransition(
          state: state,
          child: const ImoveisListScreen(),
        ),
        routes: [
          GoRoute(
            path: 'novo',
            name: 'imovel-novo',
            pageBuilder: (context, state) => _slideTransition(
              state: state,
              child: const ImovelFormScreen(imovelId: null),
            ),
          ),
          GoRoute(
            path: ':id',
            name: 'imovel-detail',
            pageBuilder: (context, state) {
              final id = int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
              return _slideTransition(
                state: state,
                child: ImovelDetailScreen(imovelId: id),
              );
            },
            routes: [
              GoRoute(
                path: 'editar',
                name: 'imovel-edit',
                pageBuilder: (context, state) {
                  final id =
                      int.tryParse(state.pathParameters['id'] ?? '') ?? 0;
                  return _slideTransition(
                    state: state,
                    child: ImovelFormScreen(imovelId: id),
                  );
                },
              ),
            ],
          ),
        ],
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Text('Rota não encontrada: ${state.error}'),
      ),
    ),
  );
});

// Transições customizadas
CustomTransitionPage<void> _fadeTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, _, child) {
      return FadeTransition(opacity: animation, child: child);
    },
  );
}

CustomTransitionPage<void> _slideTransition({
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionDuration: const Duration(milliseconds: 280),
    transitionsBuilder: (context, animation, _, child) {
      final tween = Tween(
        begin: const Offset(1.0, 0.0),
        end: Offset.zero,
      ).chain(CurveTween(curve: Curves.easeInOut));
      return SlideTransition(
        position: animation.drive(tween),
        child: child,
      );
    },
  );
}
