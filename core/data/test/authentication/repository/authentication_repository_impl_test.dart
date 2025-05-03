import 'package:api/api.dart';
import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart' hide Role;
import 'package:firebase_auth/firebase_auth.dart' hide User;
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:session_storage/session_storage.dart' as session_storage;

import '../../helpers/mock_api_client.dart';

void main() {
  group('$AuthenticationRepositoryImpl', () {
    late FirebaseAuth firebaseAuth;
    late AuthenticationRepositoryImpl authenticationRepositoryImpl;
    late ApiClient apiClient;
    late session_storage.SessionStorage sessionStorage;

    setUp(() {
      apiClient = MockApiClient();
      firebaseAuth = _MockFirebaseAuth();
      sessionStorage = MockSessionStorage();
      authenticationRepositoryImpl = AuthenticationRepositoryImpl(
        apiClient,
        firebaseAuth,
        sessionStorage,
      );
    });

    group('requestPhoneVerification', () {
      const phoneNumber = '+251923000000';
      final phoneAuthCredential = _MockPhoneAuthCredential();

      test('should sign in and emit StatusOtpVerificationComplete when '
          'verification is completed', () async {
        when(
          () => firebaseAuth.signInWithCredential(phoneAuthCredential),
        ).thenAnswer((_) async => _FakeUserCredential());
        when(
          () => firebaseAuth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            codeSent: any(named: 'codeSent'),
            verificationFailed: any(named: 'verificationFailed'),
            verificationCompleted: any(named: 'verificationCompleted'),
            codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
          ),
        ).thenAnswer((invocation) async {
          final PhoneVerificationCompleted onCompleted =
              invocation.namedArguments[#verificationCompleted];
          onCompleted(phoneAuthCredential);
        });

        await expectLater(
          authenticationRepositoryImpl.requestPhoneVerification(phoneNumber),
          emitsInOrder([const StatusOtpVerificationComplete(), emitsDone]),
        );
        verify(
          () => firebaseAuth.signInWithCredential(phoneAuthCredential),
        ).called(1);
      });

      test('should emit StatusOtpVerificationFailed when verification is '
          'completed and signing in fails', () async {
        final signInException = FirebaseAuthException(
          code: 'invalid-verification-code',
        );
        when(
          () => firebaseAuth.signInWithCredential(phoneAuthCredential),
        ).thenThrow(signInException);
        when(
          () => firebaseAuth.verifyPhoneNumber(
            phoneNumber: phoneNumber,
            codeSent: any(named: 'codeSent'),
            verificationFailed: any(named: 'verificationFailed'),
            verificationCompleted: any(named: 'verificationCompleted'),
            codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
          ),
        ).thenAnswer((invocation) async {
          final PhoneVerificationCompleted onCompleted =
              invocation.namedArguments[#verificationCompleted];
          onCompleted(phoneAuthCredential);
        });

        await expectLater(
          authenticationRepositoryImpl.requestPhoneVerification(phoneNumber),
          emitsInOrder([
            const StatusOtpVerificationFailed(OtpVerificationError.invalidOtp),
            emitsDone,
          ]),
        );
        verify(
          () => firebaseAuth.signInWithCredential(phoneAuthCredential),
        ).called(1);
      });

      test(
        'should emit StatusOtpVerificationFailed when verification fails',
        () async {
          when(
            () => firebaseAuth.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              codeSent: any(named: 'codeSent'),
              verificationFailed: any(named: 'verificationFailed'),
              verificationCompleted: any(named: 'verificationCompleted'),
              codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
            ),
          ).thenAnswer((invocation) async {
            final PhoneVerificationFailed onFail =
                invocation.namedArguments[#verificationFailed];
            onFail(FirebaseAuthException(code: 'invalid-phone-number'));
          });

          await expectLater(
            authenticationRepositoryImpl.requestPhoneVerification(phoneNumber),
            emitsInOrder([
              const StatusOtpVerificationFailed(
                OtpVerificationError.invalidPhoneNumber,
              ),
              emitsDone,
            ]),
          );
        },
      );

      test(
        'should emit StatusOtpCodeSent when verification code is sent',
        () async {
          const resendToken = 1213;
          const verificationId = 'verification-id';
          when(
            () => firebaseAuth.verifyPhoneNumber(
              phoneNumber: phoneNumber,
              codeSent: any(named: 'codeSent'),
              verificationFailed: any(named: 'verificationFailed'),
              verificationCompleted: any(named: 'verificationCompleted'),
              codeAutoRetrievalTimeout: any(named: 'codeAutoRetrievalTimeout'),
            ),
          ).thenAnswer((invocation) async {
            final PhoneCodeSent onCodeSent =
                invocation.namedArguments[#codeSent];
            onCodeSent(verificationId, resendToken);
          });

          await expectLater(
            authenticationRepositoryImpl.requestPhoneVerification(phoneNumber),
            emits(
              const StatusOtpCodeSent(
                phoneNumber: phoneNumber,
                resendToken: resendToken,
                verificationId: verificationId,
              ),
            ),
          );
        },
      );
    });

    group('verifyPhoneOtp', () {
      const String otp = '123456';
      const String verificationId = '1234';
      final credentials = PhoneAuthProvider.credential(
        verificationId: verificationId,
        smsCode: otp,
      );

      test('should return unit when successful', () async {
        registerFallbackValue(credentials);
        when(
          () => firebaseAuth.signInWithCredential(any()),
        ).thenAnswer((_) async => _FakeUserCredential());

        final response = await authenticationRepositoryImpl.verifyPhoneOtp(
          otp,
          verificationId,
        );

        expect(response.isRight(), isTrue);
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });

      test('should return verification error when sign in fails', () async {
        registerFallbackValue(credentials);
        when(() => firebaseAuth.signInWithCredential(any())).thenAnswer(
          (_) async =>
              throw FirebaseAuthException(code: 'invalid-verification-code'),
        );

        final response = await authenticationRepositoryImpl.verifyPhoneOtp(
          otp,
          verificationId,
        );

        expect(
          response,
          left(
            const StatusOtpVerificationFailed(OtpVerificationError.invalidOtp),
          ),
        );
        verify(() => firebaseAuth.signInWithCredential(any())).called(1);
      });
    });

    group('signIn', () {
      test('should save session when successful', () async {
        const request = SignInFormDto(
          phoneNumber: '+251923000000',
          password: 'password',
        );

        when(
          () => sessionStorage.saveSession(
            const session_storage.UserSession(
              accessToken: 'access-token',
              refreshToken: 'refresh-token',
              user: session_storage.User(
                id: 1,
                phoneNumber: '+251923000000',
                firstName: 'John',
                lastName: 'Doe',
                role: session_storage.Role.user,
              ),
            ),
          ),
        ).thenAnswer((_) async {});

        when(
          () => apiClient.authentication.signIn(
            SignInRequest(
              phoneNumber: request.phoneNumber,
              password: request.password,
            ),
          ),
        ).thenAnswer(
          (_) async => right(
            const SignInResponse(
              user: User(
                id: 1,
                phoneNumber: '+251923000000',
                firstName: 'John',
                lastName: 'Doe',
                role: Role.user,
              ),
              accessToken: 'access-token',
              refreshToken: 'refresh-token',
            ),
          ),
        );

        await authenticationRepositoryImpl.signIn(request);

        verify(
          () => sessionStorage.saveSession(
            const session_storage.UserSession(
              accessToken: 'access-token',
              refreshToken: 'refresh-token',
              user: session_storage.User(
                id: 1,
                phoneNumber: '+251923000000',
                firstName: 'John',
                lastName: 'Doe',
                role: session_storage.Role.user,
              ),
            ),
          ),
        ).called(1);
      });

      test('should return error when unsuccessful', () async {
        const request = SignInFormDto(
          phoneNumber: '+251923000000',
          password: 'password',
        );

        when(
          () => apiClient.authentication.signIn(
            SignInRequest(
              phoneNumber: request.phoneNumber,
              password: request.password,
            ),
          ),
        ).thenAnswer((_) async => left(const ApiNetworkError.timeout()));

        final response = await authenticationRepositoryImpl.signIn(request);

        expect(response, left(const ApiNetworkError.timeout()));
      });
    });
  });
}

class _FakeUserCredential extends Fake implements UserCredential {}

class _MockFirebaseAuth extends Mock implements FirebaseAuth {}

class _MockPhoneAuthCredential extends Mock implements PhoneAuthCredential {}

class MockSessionStorage extends Mock
    implements session_storage.SessionStorage {}
