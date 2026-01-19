import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../notifications/presentation/services/notification_service.dart';

class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth _auth;

  FirebaseAuthRepository(this._auth);

  @override
  Stream<UserEntity?> get authStateChanges => _auth.authStateChanges().map(_userFromFirebase);

  @override
  UserEntity? get currentUser => _userFromFirebase(_auth.currentUser);

  @override
  Future<UserEntity?> signIn(String email, String password) async {
    final credential = await _auth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    await _saveFcmToken(credential.user?.uid);
    return _userFromFirebase(credential.user);
  }

  @override
  Future<UserEntity?> signUp(String email, String password, String name) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
    await credential.user?.updateDisplayName(name);
    await _saveFcmToken(credential.user?.uid);
    return _userFromFirebase(credential.user);
  }

  @override
  Future<void> signOut() => _auth.signOut();

  Future<void> _saveFcmToken(String? userId) async {
    if (userId == null) return;
    
    final token = NotificationService().fcmToken;
    if (token != null) {
      await FirebaseFirestore.instance.collection('users').doc(userId).set({
        'fcmToken': token,
        'tokenUpdatedAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
  }

  UserEntity? _userFromFirebase(User? user) {
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName,
      photoUrl: user.photoURL,
    );
  }
}
