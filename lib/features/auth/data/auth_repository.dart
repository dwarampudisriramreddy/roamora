import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:roamora/features/profile/data/user_repository.dart';
import 'package:roamora/features/profile/domain/user_model.dart';

part 'auth_repository.g.dart';

class AuthRepository {
  final FirebaseAuth _auth;
  final GoogleSignIn _googleSignIn;
  final UserRepository _userRepository;

  AuthRepository(this._auth, this._googleSignIn, this._userRepository);

  Stream<User?> authStateChanges() => _auth.authStateChanges();

  User? get currentUser => _auth.currentUser;

  Future<UserCredential?> signInWithGoogle() async {
    UserCredential? credential;
    if (kIsWeb) {
      final googleProvider = GoogleAuthProvider();
      credential = await _auth.signInWithPopup(googleProvider);
    } else {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) return null;

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final OAuthCredential oAuthCredential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      credential = await _auth.signInWithCredential(oAuthCredential);
    }

    final user = credential.user;
    if (user != null) {
      debugPrint('AuthRepository: Signed in user email: ${user.email}');
      // Check if user already exists
      final userDoc = await _userRepository.getUser(user.uid).first;
      final email = user.email ?? '';
      
      if (userDoc == null) {
        debugPrint('AuthRepository: Creating profile with email: $email');
        await _userRepository.createUserProfile(UserModel(
          uid: user.uid,
          email: email,
          photoURL: user.photoURL,
          createdAt: DateTime.now(),
        ));
      } else if (userDoc.email.isEmpty && email.isNotEmpty) {
        debugPrint('AuthRepository: Updating profile with email: $email');
        await _userRepository.updateUserProfile(userDoc.copyWith(email: email));
      }
    }
    return credential;
  }

  Future<void> signOut() async {
    if (!kIsWeb) {
      await _googleSignIn.signOut();
    }
    await _auth.signOut();
  }
}

@riverpod
FirebaseAuth firebaseAuth(FirebaseAuthRef ref) {
  return FirebaseAuth.instance;
}

@riverpod
GoogleSignIn googleSignIn(GoogleSignInRef ref) {
  // Replace 'YOUR_WEB_CLIENT_ID_HERE' with your actual Web Client ID
  // found in Firebase Console > Project Settings > General > Your Apps > Web App (or Android config)
  return GoogleSignIn(
    clientId: '553315913700-phfi41sm9d7n45d2k70jhihal2qjbn0n.apps.googleusercontent.com',
  );
}

@riverpod
AuthRepository authRepository(AuthRepositoryRef ref) {
  return AuthRepository(
    ref.watch(firebaseAuthProvider),
    ref.watch(googleSignInProvider),
    ref.watch(userRepositoryProvider),
  );
}

@riverpod
Stream<User?> authState(AuthStateRef ref) {
  return ref.watch(authRepositoryProvider).authStateChanges();
}
