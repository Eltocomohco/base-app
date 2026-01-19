import 'package:firebase_auth/firebase_auth.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:pizzeria_pepe_app/features/auth/domain/entities/user_entity.dart';
import 'package:pizzeria_pepe_app/features/auth/domain/repositories/auth_repository.dart';
import 'package:pizzeria_pepe_app/features/auth/data/repositories/firebase_auth_repository.dart';

part 'auth_provider.g.dart';

@riverpod
AuthRepository authRepository(Ref ref) {
  return FirebaseAuthRepository(FirebaseAuth.instance);
}

@riverpod
Stream<UserEntity?> authState(Ref ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
}

@riverpod
class Auth extends _$Auth {
  @override
  UserEntity? build() {
    final userAsync = ref.watch(authStateProvider);
    return userAsync.value;
  }

  Future<void> login(String email, String password) async {
    await ref.read(authRepositoryProvider).signIn(email, password);
  }

  Future<void> register(String email, String password, String name) async {
    await ref.read(authRepositoryProvider).signUp(email, password, name);
  }

  Future<void> logout() async {
    await ref.read(authRepositoryProvider).signOut();
  }
}
