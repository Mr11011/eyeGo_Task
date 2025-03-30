import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'auth_states.dart';

class AuthCubit extends Cubit<AuthStates> {
  final FirebaseAuth _firebaseAuth;
  final FlutterSecureStorage _secureStorage;
  AuthCubit({
    required FirebaseAuth firebaseAuth,
    required FlutterSecureStorage secureStorage,
  })  : _firebaseAuth = firebaseAuth,
        _secureStorage = secureStorage,
        super(AuthInitState());

  Future<void> signUp(
    String email,
    String password,
  ) async {
    emit(AuthLoadingState());
    User? user;

    try {
      final userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
          email: email, password: password);

      user = userCredential.user;
      if (user == null) {
        emit(AuthErrorState("User creation failed"));
        return;
      }
      await saveUserToken(user);
      emit(AuthSuccessState(user));
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        emit(AuthErrorState("Weak Password"));

        debugPrint('The password provided is too weak');
      } else if (e.code == 'email-already-in-use') {
        emit(AuthErrorState("Email already in use"));

        debugPrint('An account already exists with that email.');
      } else {
        emit(AuthErrorState(e.code.toString()));
      }
    } catch (e) {
      if (user != null) {
        await user.delete(); // Delete auth user if Firestore fails
      }
      emit(AuthErrorState('Registration failed. Please try again'));
    }
  }

  Future<void> signIn(String email, String password) async {
    emit(AuthLoadingState());
    try {
      final userCredential = await _firebaseAuth.signInWithEmailAndPassword(
          email: email, password: password);
      final user = userCredential.user;
      if (user == null) {
        emit(AuthErrorState("User not found"));
        return;
      }

      await saveUserToken(user);
      emit(AuthSuccessState(user));
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';
      switch (e.code) {
        case 'invalid-email':
          message = 'Invalid email format';
          break;
        case 'user-disabled':
          message = 'Account disabled';
          break;
        case 'account-exists-with-different-credential':
          message = 'Account linked to another provider';
          break;
        case 'user-not-found':
          message = 'No account found';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'too-many-requests':
          message = 'Too many attempts. Try again later';
          break;
        default:
          message = 'Login failed. Please try again';
      }
      emit(AuthErrorState(message));
    } catch (e) {
      emit(AuthErrorState('An unexpected error occurred'));
    }
  }

  Future<void> signOut() async {
    await _secureStorage.delete(key: 'authToken');
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      emit(AuthErrorState("Failed to sign out"));
    }
    emit(AuthSignOutState());
  }

  Future<void> saveUserToken(User user) async {
    try {
      final token = await user.getIdToken();

      if (token != null) {
        await _secureStorage.write(key: "authToken", value: token);
      }

      if (kDebugMode) {
        debugPrint("User Token: $token");
        final securedStorage = await _secureStorage.read(key: "authToken");
        debugPrint("User Token read: $securedStorage");
      }
    } catch (e) {
      debugPrint("save user token is failed");
    }
  }
  Future<bool> isUserLoggedIn() async {
    final token = await _secureStorage.read(key: "authToken");
    return token != null;
  }

}
