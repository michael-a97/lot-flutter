part of 'authentication_repository.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final FirebaseAuth _firebaseAuth;

  const AuthenticationRepositoryImpl(this._firebaseAuth);

  @override
  Stream<PhoneVerificationStatus> requestPhoneVerification(
    String phoneNumber, [
    int? resendToken,
  ]) async* {
    final controller = StreamController<PhoneVerificationStatus>();
    await _firebaseAuth.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      forceResendingToken: resendToken,
      verificationCompleted: (credential) async {
        try {
          await _firebaseAuth.signInWithCredential(credential);
          controller.add(const StatusOtpVerificationComplete());
        } on FirebaseAuthException catch (e) {
          final error = OtpVerificationError.fromFirebase(e.code);
          controller.add(StatusOtpVerificationFailed(error));
        }
        await controller.close();
      },
      verificationFailed: (e) {
        final error = OtpVerificationError.fromFirebase(e.code);
        controller.add(StatusOtpVerificationFailed(error));
        controller.close();
      },
      codeSent: (verificationId, resendToken) {
        controller.add(
          StatusOtpCodeSent(
            resendToken: resendToken,
            phoneNumber: phoneNumber,
            verificationId: verificationId,
          ),
        );
      },
      codeAutoRetrievalTimeout: (verificationId) {},
    );

    yield* controller.stream.asBroadcastStream();
  }

  @override
  Future<Either<StatusOtpVerificationFailed, Unit>> verifyPhoneOtp(
    String otp,
    String verificationId,
  ) async {
    try {
      final credentials = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );
      await _firebaseAuth.signInWithCredential(credentials);
      return right(unit);
    } on FirebaseAuthException catch (e) {
      final error = OtpVerificationError.fromFirebase(e.code);
      return left(StatusOtpVerificationFailed(error));
    }
  }
}
