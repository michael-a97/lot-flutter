import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:lot/features/phone_number_verification/application/phone_number_verification_cubit.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('$PhoneNumberVerificationCubit', () {
    late PhoneNumberVerificationCubit otpVerificationCubit;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = _MockAuthenticationRepository();
      otpVerificationCubit = PhoneNumberVerificationCubit(
        authenticationRepository,
      );
    });

    tearDown(() => otpVerificationCubit.close());

    group('requestOtpVerification', () {
      const phoneNumber = '+251923000000';
      const otpSentStatus = StatusOtpCodeSent(
        resendToken: 1234,
        verificationId: '1234',
        phoneNumber: phoneNumber,
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, codeSent, completed ] when verification is '
        'successfully completed',
        setUp: () {
          when(
            () =>
                authenticationRepository.requestPhoneVerification(phoneNumber),
          ).thenAnswer(
            (_) => Stream.fromIterable([
              otpSentStatus,
              const StatusOtpVerificationComplete(),
            ]),
          );
        },
        build: () => otpVerificationCubit,
        act: (cubit) => cubit.requestOtpVerification(phoneNumber),
        expect:
            () => [
              const PhoneNumberVerificationState(isLoading: true),
              PhoneNumberVerificationState(
                status: otpSentStatus,
                phoneNumber: otpSentStatus.phoneNumber,
                resendToken: otpSentStatus.resendToken,
                verificationId: otpSentStatus.verificationId,
              ),
              const PhoneNumberVerificationState(
                status: StatusOtpVerificationComplete(),
              ),
            ],
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, error ] when verification is failed',
        setUp: () {
          when(
            () =>
                authenticationRepository.requestPhoneVerification(phoneNumber),
          ).thenAnswer(
            (_) => Stream.value(
              const StatusOtpVerificationFailed(
                OtpVerificationError.invalidOtp,
              ),
            ),
          );
        },
        build: () => otpVerificationCubit,
        act: (cubit) => cubit.requestOtpVerification(phoneNumber),
        expect:
            () => [
              const PhoneNumberVerificationState(isLoading: true),
              const PhoneNumberVerificationState(
                status: StatusOtpVerificationFailed(
                  OtpVerificationError.invalidOtp,
                ),
              ),
            ],
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, timeout ] when verification is timed out',
        setUp: () {
          when(
            () =>
                authenticationRepository.requestPhoneVerification(phoneNumber),
          ).thenAnswer(
            (_) => Stream.value(
              const StatusOtpVerificationFailed(
                OtpVerificationError.invalidOtp,
              ),
            ),
          );
        },
        build: () => otpVerificationCubit,
        act: (cubit) => cubit.requestOtpVerification(phoneNumber),
        expect:
            () => [
              const PhoneNumberVerificationState(isLoading: true),
              const PhoneNumberVerificationState(
                status: StatusOtpVerificationFailed(
                  OtpVerificationError.invalidOtp,
                ),
              ),
            ],
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, error ] when verification is failed with '
        'unknown error',
        setUp: () {
          when(
            () =>
                authenticationRepository.requestPhoneVerification(phoneNumber),
          ).thenAnswer(
            (_) => Stream.value(const InvalidPhoneVerificationStatus()),
          );
        },
        build: () => otpVerificationCubit,
        act: (cubit) => cubit.requestOtpVerification(phoneNumber),
        expect:
            () => [
              const PhoneNumberVerificationState(isLoading: true),
              const PhoneNumberVerificationState(
                status: StatusOtpVerificationFailed(
                  OtpVerificationError.unknown,
                ),
              ),
            ],
      );
    });

    blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
      'should emit [ initial ] when resetting for resend',
      seed:
          () => const PhoneNumberVerificationState(
            phoneNumber: '+251923000000',
            verificationId: '1234',
          ),
      build: () => otpVerificationCubit,
      act: (cubit) => cubit.resetForResend(),
      expect:
          () => [
            const PhoneNumberVerificationState(phoneNumber: '+251923000000'),
          ],
    );

    group('resendOtpVerification', () {
      const resendToken = 1234;
      const verificationId = '1234';
      const phoneNumber = '+251923000000';
      const otpSentStatus = StatusOtpCodeSent(
        phoneNumber: phoneNumber,
        resendToken: resendToken,
        verificationId: verificationId,
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, codeSent ] when otp is resent',
        setUp: () {
          when(
            () => authenticationRepository.requestPhoneVerification(
              phoneNumber,
              resendToken,
            ),
          ).thenAnswer((_) => Stream.value(otpSentStatus));
        },
        build: () => otpVerificationCubit,
        seed:
            () => const PhoneNumberVerificationState(
              phoneNumber: phoneNumber,
              resendToken: resendToken,
              verificationId: verificationId,
            ),
        act: (bloc) => otpVerificationCubit.resendOtpVerification(),
        expect:
            () => [
              const PhoneNumberVerificationState(
                isLoading: true,
                phoneNumber: phoneNumber,
                resendToken: resendToken,
                verificationId: verificationId,
              ),
              const PhoneNumberVerificationState(
                status: otpSentStatus,
                phoneNumber: phoneNumber,
                resendToken: resendToken,
                verificationId: verificationId,
              ),
            ],
      );
    });

    group('verifyOtp', () {
      const otpCode = '123456';
      const resendToken = 1234;
      const verificationId = '1234';
      const phoneNumber = '+251923000000';
      const otpSentStatus = StatusOtpCodeSent(
        resendToken: resendToken,
        phoneNumber: phoneNumber,
        verificationId: verificationId,
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, completed ] when the otp verification is '
        'completed',
        build: () => otpVerificationCubit,
        setUp: () {
          when(
            () => authenticationRepository.verifyPhoneOtp(
              otpCode,
              verificationId,
            ),
          ).thenAnswer((_) async => right(unit));
        },
        seed:
            () => const PhoneNumberVerificationState(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              resendToken: resendToken,
              status: otpSentStatus,
            ),
        act: (cubit) => cubit.verifyOtp(otpCode),
        expect:
            () => [
              const PhoneNumberVerificationState(
                verificationId: verificationId,
                resendToken: resendToken,
                phoneNumber: phoneNumber,
                status: otpSentStatus,
                isLoading: true,
              ),
              const PhoneNumberVerificationState(
                status: StatusOtpVerificationComplete(),
              ),
            ],
      );

      blocTest<PhoneNumberVerificationCubit, PhoneNumberVerificationState>(
        'should emit [ loading, error ] when otp verification fails',
        build: () => otpVerificationCubit,
        setUp: () {
          when(
            () =>
                authenticationRepository.requestPhoneVerification(phoneNumber),
          ).thenAnswer((_) => Stream.value(otpSentStatus));
          when(
            () => authenticationRepository.verifyPhoneOtp(
              otpCode,
              verificationId,
            ),
          ).thenAnswer(
            (_) async => left(
              const StatusOtpVerificationFailed(
                OtpVerificationError.invalidOtp,
              ),
            ),
          );
        },
        seed:
            () => const PhoneNumberVerificationState(
              verificationId: verificationId,
              phoneNumber: phoneNumber,
              resendToken: resendToken,
              status: otpSentStatus,
            ),
        act: (cubit) => cubit.verifyOtp(otpCode),
        expect:
            () => [
              const PhoneNumberVerificationState(
                verificationId: verificationId,
                phoneNumber: phoneNumber,
                resendToken: resendToken,
                status: otpSentStatus,
                isLoading: true,
              ),
              const PhoneNumberVerificationState(
                phoneNumber: phoneNumber,
                resendToken: resendToken,
                verificationId: verificationId,
                status: StatusOtpVerificationFailed(
                  OtpVerificationError.invalidOtp,
                ),
              ),
            ],
      );
    });
  });
}

class InvalidPhoneVerificationStatus extends PhoneVerificationStatus {
  const InvalidPhoneVerificationStatus();
}

class _MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}
