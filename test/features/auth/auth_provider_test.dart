
import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pizzeria_pepe_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:pizzeria_pepe_app/features/auth/domain/entities/user_entity.dart';
import 'package:pizzeria_pepe_app/features/auth/domain/repositories/auth_repository.dart';

class MockAuthRepository implements AuthRepository {
  final _controller = StreamController<UserEntity?>();
  UserEntity? _currentUser;

  @override
  Stream<UserEntity?> get authStateChanges => _controller.stream;

  @override
  UserEntity? get currentUser => _currentUser;

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    if (email == 'error@test.com') throw Exception('Invalid credentials');
    _currentUser = UserEntity(id: '1', email: email, name: 'Test User');
    _controller.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<UserEntity?> signUp(String email, String password, String name) async {
    _currentUser = UserEntity(id: '1', email: email, name: name);
    _controller.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    _currentUser = null;
    _controller.add(null);
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  group('AuthNotifier tests', () {
    late MockAuthRepository mockRepo;
    late ProviderContainer container;

    setUp(() {
      mockRepo = MockAuthRepository();
      container = ProviderContainer(
        overrides: [
          authRepositoryProvider.overrideWithValue(mockRepo),
        ],
      );
    });

    tearDown(() {
      mockRepo.dispose();
      container.dispose();
    });

    test('Initial state reflects current user (null)', () {
      final user = container.read(authProvider);
      expect(user, isNull);
    });

    test('login updates auth state correctly', () async {
      final listener = container.listen(authProvider, (prev, next) {}, fireImmediately: true);
      
      await container.read(authProvider.notifier).login('test@test.com', '123456');
      
      // Give the stream a moment to propagate through the providers
      await Future.delayed(Duration.zero);
      
      final user = container.read(authProvider);
      expect(user?.email, 'test@test.com');
      
      listener.close();
    });

    test('logout clears auth state', () async {
      final listener = container.listen(authProvider, (prev, next) {}, fireImmediately: true);
      
      await container.read(authProvider.notifier).login('test@test.com', '123456');
      await Future.delayed(Duration.zero);
      expect(container.read(authProvider), isNotNull);

      await container.read(authProvider.notifier).logout();
      await Future.delayed(Duration.zero);

      expect(container.read(authProvider), isNull);
      
      listener.close();
    });

    test('register updates state with name', () async {
      final listener = container.listen(authProvider, (prev, next) {}, fireImmediately: true);
      
      await container.read(authProvider.notifier).register('new@test.com', '123', 'Pepe');
      await Future.delayed(Duration.zero);

      expect(container.read(authProvider)?.name, 'Pepe');
      
      listener.close();
    });
  });
}
