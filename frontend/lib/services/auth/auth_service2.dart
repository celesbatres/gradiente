import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'auth_exceptions.dart';

class AuthService {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  User? getCurrentUser() {
    return _firebaseAuth.currentUser;
  }

  Future<UserCredential?> signIn(
      {required String email, required String password}) async {
    return await _firebaseAuth.signInWithEmailAndPassword(
        email: email, password: password);
  }

  Future<UserCredential?> signUp(
      {required String email, required String password}) async {
    return await _firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
  }

  Future<void> signOut() async {
    return await _firebaseAuth.signOut();
  }

  Future<void> resetPassword({required String email}) async {
    return await _firebaseAuth.sendPasswordResetEmail(email: email);
  }

  Future<void> updateUsername({required String username}) async {
    return await _firebaseAuth.currentUser?.updateDisplayName(username);
  }

  Future<void> deleteAccount(
      {required String email, required String password}) async {
    AuthCredential credential =
    EmailAuthProvider.credential(email: email, password: password);
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
    await _firebaseAuth.currentUser!.delete();
    await _firebaseAuth.signOut();
  }

  Future<void> resetPasswordFromCurrentPassword(
      {required String currentPassword,
        required String newPassword,
        required String email}) async {
    AuthCredential credential =
    EmailAuthProvider.credential(email: email, password: currentPassword);
    await _firebaseAuth.currentUser!.reauthenticateWithCredential(credential);
    await _firebaseAuth.currentUser!.updatePassword(newPassword);
  }


  Future<void> signOutFromGoogle() async {
    try {
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Error signing out: $e");
    }
  }
  Future<void> deleteAccountFromGoogle() async {
    try {
      await _firebaseAuth.currentUser!.delete();
      await _firebaseAuth.signOut();
    } catch (e) {
      throw Exception("Error deleting account: $e");
    }
  }
  Future<UserCredential?> signUpWithGoogle() async {
    final credential = await signInWithGoogle();

    // Si es un nuevo usuario (primera vez que se registra con Google)
    if (credential != null && credential.additionalUserInfo?.isNewUser == true) {
      // Aquí podrías guardar info extra en Firestore si necesitas
      print("Nuevo usuario registrado con Google: ${credential.user?.email}");
    }

    return credential;
  }
  Future<UserCredential?> signInWithGoogle() async {
    try {
      if (kIsWeb) {
        // --- Web ---
        final googleProvider = GoogleAuthProvider();
        googleProvider.setCustomParameters({
          'prompt': 'select_account'  // 👈 fuerza selección de cuenta siempre
        });

        return await FirebaseAuth.instance.signInWithPopup(googleProvider);
      } else {
        // --- Mobile (manteniendo tu flujo actual) ---
        await GoogleSignIn.instance.initialize();
        final GoogleSignInAccount googleUser =
        await GoogleSignIn.instance.authenticate(scopeHint: ['email']);

        final GoogleSignInClientAuthorization? authorization =
        await googleUser.authorizationClient
            .authorizationForScopes(['email']);

        final credential = GoogleAuthProvider.credential(
          idToken: googleUser.authentication.idToken,
          accessToken: authorization?.accessToken,
        );
        print("credential: $credential");
        return await FirebaseAuth.instance.signInWithCredential(credential);
      }
    } on GoogleSignInException catch (e) {
      throw TFirebaseAuthException(e.code.name).message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException {
      throw 'Invalid format';
    } catch (e) {
      throw 'Platform error occurred: $e';
    }
  }
}