class SignupWithEmailAndPasswordFailure {
  final String message;
  const SignupWithEmailAndPasswordFailure([this.message = "An Error Occured"]);

  factory SignupWithEmailAndPasswordFailure.code(String code) {
    switch (code) {
      case 'weak-password':
        return const SignupWithEmailAndPasswordFailure(
            "Please enter a stronger password.");
      case 'invalid-email':
        return const SignupWithEmailAndPasswordFailure(
            "Email is not valid or badly formatted.");
      case 'wrong-password' || 'user-not-found':
        return const SignupWithEmailAndPasswordFailure(
            "The username or password is invalid.");
      case 'email-already-in-use':
        return const SignupWithEmailAndPasswordFailure(
            "An account already exists with that email.");
      case 'operation-not-allowed':
        return const SignupWithEmailAndPasswordFailure(
            "Operation is not allowed. Please contact support.");
      case 'user-disabled':
        return const SignupWithEmailAndPasswordFailure(
            "This user has been disabled. Please contact support");
      case 'too-many-requests':
        return const SignupWithEmailAndPasswordFailure(
            "Too many requests. Please wait.");
      default:
        print(code);
        return const SignupWithEmailAndPasswordFailure();
    }
  }
}
