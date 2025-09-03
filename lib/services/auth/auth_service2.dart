import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
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

  Future<UserCredential?> signInWithGoogle() async {
    try {
      await GoogleSignIn.instance.initialize();
      final GoogleSignInAccount googleUser =
      await GoogleSignIn.instance.authenticate(scopeHint: ['email']);
      final GoogleSignInClientAuthorization? authorization;
      authorization = await googleUser.authorizationClient
          .authorizationForScopes(['email']);
      final credential = GoogleAuthProvider.credential(
        idToken: googleUser.authentication.idToken,
        accessToken: authorization?.accessToken,
      );
// Firebase sign‑in
      return await FirebaseAuth.instance.signInWithCredential(credential);
    } on GoogleSignInException catch (e) {
// if (e.code.name == 'canceled') {
// return null;
// }
      throw TFirebaseAuthException(e.code.name).message;
    } on FirebaseAuthException catch (e) {
      throw TFirebaseAuthException(e.code).message;
    } on FormatException {
      throw 'Invalid format';
    } catch (e) {
      throw 'Platform error occurred';
    }
  }

//   return await FirebaseAuth.instance.signInWithCredential(credential);
// }

// final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
//     final FirebaseAuth _auth = FirebaseAuth.instance;
//     User? _user;

// void signInwithGoogle()async
// {
//     final GoogleSignInAccount googleSignInAccount =
//           await _googleSignIn.signIn();
//     final GoogleSignInAuthentication googleSignInAuthentication =
//           await googleSignInAccount.authentication;
//     final AuthCredential credential = GoogleAuthProvider.getCredential(
//           accessToken: googleSignInAuthentication.accessToken,
//           idToken: googleSignInAuthentication.idToken,
//     );
//      await _auth.signInWithCredential(credential);
//     _user=await _auth.currentUser();
// }
}