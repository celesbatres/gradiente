class TFirebaseAuthException implements Exception {
  final String code;
  late String message;

  TFirebaseAuthException(this.code) {
    message = _getMessageFromCode(code);
  }

  String _getMessageFromCode(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Wrong password provided.';
      case 'email-already-in-use':
        return 'Email is already in use.';
      case 'invalid-email':
        return 'Email address is invalid.';
      case 'operation-not-allowed':
        return 'Operation not allowed.';
      case 'weak-password':
        return 'Please enter a stronger password.';
      case 'user-disabled':
        return 'This user has been disabled.';
      case 'too-many-requests':
        return 'Too many requests. Try again later.';
      case 'invalid-credential':
        return 'The credential is invalid.';
      case 'account-exists-with-different-credential':
        return 'An account already exists with the same email address.';
      case 'canceled':
        return 'Sign in canceled by user.';
      default:
        return 'An error occurred. Please try again.';
    }
  }
}
