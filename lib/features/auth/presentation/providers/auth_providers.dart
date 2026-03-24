import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/repositories/auth_repository_impl.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/usecases/login_usecase.dart';

// ---------- Infraestrutura ----------

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl();
});

final loginUseCaseProvider = Provider<LoginUseCase>((ref) {
  return LoginUseCase(ref.read(authRepositoryProvider));
});

// ---------- Estado de autenticação ----------

enum AuthStatus { initial, loading, authenticated, unauthenticated, error }

class AuthState {
  final AuthStatus status;
  final UserEntity? user;
  final String? errorMessage;

  const AuthState({
    this.status = AuthStatus.initial,
    this.user,
    this.errorMessage,
  });

  AuthState copyWith({
    AuthStatus? status,
    UserEntity? user,
    String? errorMessage,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
      errorMessage: errorMessage,
    );
  }

  bool get isAuthenticated => status == AuthStatus.authenticated;
}

class AuthNotifier extends Notifier<AuthState> {
  @override
  AuthState build() => const AuthState(status: AuthStatus.unauthenticated);

  Future<void> login(String email, String password) async {
    state = state.copyWith(status: AuthStatus.loading);
    try {
      final user = await ref.read(loginUseCaseProvider).call(email, password);
      if (user != null) {
        state = AuthState(status: AuthStatus.authenticated, user: user);
      } else {
        state = const AuthState(
          status: AuthStatus.error,
          errorMessage: 'E-mail ou senha incorretos.',
        );
      }
    } catch (e) {
      state = const AuthState(
        status: AuthStatus.error,
        errorMessage: 'Erro ao fazer login. Tente novamente.',
      );
    }
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).logout();
    state = const AuthState(status: AuthStatus.unauthenticated);
  }
}

final authNotifierProvider =
    NotifierProvider<AuthNotifier, AuthState>(AuthNotifier.new);
