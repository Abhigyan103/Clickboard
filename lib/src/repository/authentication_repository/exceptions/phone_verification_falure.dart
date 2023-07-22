class PhoneVerificationFailure {
  final String message;
  const PhoneVerificationFailure([this.message = "An Error Occured"]);

  factory PhoneVerificationFailure.code(String code) {
    switch (code) {
      case 'invalid-phone-number':
        return const PhoneVerificationFailure(
            "Please enter a valid phone number.");
      // case 'invalid-email':
      //   return const PhoneVerificationFailure(
      //       "Email is not valid or badly formatted.");
      // case 'wrong-password' || 'user-not-found':
      //   return const PhoneVerificationFailure(
      //       "The username or password is invalid.");
      // case 'email-already-in-use':
      //   return const PhoneVerificationFailure(
      //       "An account already exists with that email.");
      // case 'operation-not-allowed':
      //   return const PhoneVerificationFailure(
      //       "Operation is not allowed. Please contact support.");
      // case 'user-disabled':
      //   return const PhoneVerificationFailure(
      //       "This user has been disabled. Please contact support");
      // case 'too-many-requests':
      //   return const PhoneVerificationFailure(
      //       "Too many requests. Please wait.");
      default:
        return const PhoneVerificationFailure();
    }
  }
}
