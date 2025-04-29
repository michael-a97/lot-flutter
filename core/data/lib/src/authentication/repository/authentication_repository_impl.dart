part of 'authentication_repository.dart';

@Injectable(as: AuthenticationRepository)
class AuthenticationRepositoryImpl implements AuthenticationRepository {
  final ApiClient _apiClient;
  final FirebaseAuth _firebaseAuth;
  final SessionStorage _sessionStorage;

  const AuthenticationRepositoryImpl(
    this._apiClient,
    this._firebaseAuth,
    this._sessionStorage,
  );

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

  @override
  Future<NetworkResponse<SignInResponseDto>> signIn(
    SignInFormDto request,
  ) async {
    final response = await _apiClient.authentication.signIn(request.toApi());
    if (response.isRight()) {
      final session = response.toOption().toNullable()!;
      await _sessionStorage.saveSession(
        UserSession(
          accessToken: session.accessToken,
          refreshToken: session.refreshToken,
          user: session.user.toUserSessionStorageModel(),
        ),
      );
    }
    return response.map((it) => it.toDto());
  }

  @override
  Future<void> signOut() async {
    await _sessionStorage.deleteSession();
    await _firebaseAuth.signOut();
  }

  @override
  Future<bool> isUserAuthenticated() async {
    final session = await _sessionStorage.getSession();
    return session != null;
  }
}
