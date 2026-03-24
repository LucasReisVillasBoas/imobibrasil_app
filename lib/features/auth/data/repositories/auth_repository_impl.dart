import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  UserEntity? _currentUser;

  @override
  Future<UserEntity?> login(String email, String password) async {
    await Future<void>.delayed(const Duration(milliseconds: 800));
    if (email == kLoginEmail && password == kLoginPassword) {
      _currentUser = const UserEntity(
        email: kLoginEmail,
        name: kUserName,
      );
      return _currentUser;
    }
    return null;
  }

  @override
  Future<void> logout() async {
    _currentUser = null;
  }

  @override
  UserEntity? getCurrentUser() => _currentUser;

  @override
  bool get isAuthenticated => _currentUser != null;
}
