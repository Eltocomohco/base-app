import 'package:pizzeria_pepe_app/features/auth/domain/entities/user_entity.dart';

abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;
  Future<UserEntity?> signIn(String email, String password);
  Future<UserEntity?> signUp(String email, String password, String name);
  Future<void> signOut();
  UserEntity? get currentUser;
}
