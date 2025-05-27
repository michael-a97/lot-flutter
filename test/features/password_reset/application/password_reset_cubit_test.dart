import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:lot/features/password_reset/password_reset.dart';
import 'package:lot/features/sign_up/application/form/sign_up_form.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('$PasswordResetCubit', () {
    late PasswordResetCubit passwordResetCubit;
    late AuthenticationRepository authenticationRepository;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      passwordResetCubit = PasswordResetCubit(authenticationRepository);
    });

    group('onPhoneNumberChanged', () {
      const phoneNumber = '1234567890';
      blocTest(
        'should emit [PasswordResetState] with updated phone number',
        build: () => passwordResetCubit,
        act: (cubit) => cubit.onPhoneNumberChanged(phoneNumber),
        expect: () => const [PasswordResetState(phoneNumber: phoneNumber)],
      );
    });

    group('onPhoneNumberValidChanged', () {
      const valid = true;
      blocTest(
        'should emit [PasswordResetState] with updated phone number validity',
        build: () => passwordResetCubit,
        act: (cubit) => cubit.onPhoneNumberValidated(isValid: valid),
        expect: () => const [PasswordResetState(isPhoneNumberValid: valid)],
      );
    });

    group('onPasswordChanged', () {
      const password = 'newPassword123';
      blocTest(
        'should emit [PasswordResetState] with updated password input',
        build: () => passwordResetCubit,
        act: (cubit) => cubit.onPasswordChanged(password),
        expect:
            () => const [
              PasswordResetState(passwordInput: PasswordInput.dirty(password)),
            ],
      );
    });

    group('submit', () {
      const password = 'P@ssw0rd!';
      const phoneNumber = '123456789';

      blocTest(
        'should emit [PasswordResetState, PasswordResetState] with loading and '
        'success statuses when submission is successful',
        build: () => passwordResetCubit,
        seed:
            () => const PasswordResetState(
              phoneNumber: phoneNumber,
              passwordInput: PasswordInput.dirty(password),
              isPhoneNumberValid: true,
            ),
        setUp: () {
          when(
            () => authenticationRepository.resetPassword(
              const PasswordResetRequestDto(
                phoneNumber: phoneNumber,
                newPassword: password,
              ),
            ),
          ).thenAnswer((_) async => right(unit));
        },
        act: (cubit) => cubit.submit(),
        expect:
            () => const [
              PasswordResetState(
                status: FormzSubmissionStatus.inProgress,
                phoneNumber: phoneNumber,
                passwordInput: PasswordInput.dirty(password),
                isPhoneNumberValid: true,
              ),
              PasswordResetState(
                status: FormzSubmissionStatus.success,
                phoneNumber: phoneNumber,
                passwordInput: PasswordInput.dirty(password),
                isPhoneNumberValid: true,
              ),
            ],
      );

      blocTest(
        'should emit [PasswordResetState, PasswordResetState] with loading and '
        'failure statuses when unsuccessful',
        build: () => passwordResetCubit,
        seed:
            () => const PasswordResetState(
              phoneNumber: phoneNumber,
              passwordInput: PasswordInput.dirty(password),
              isPhoneNumberValid: true,
            ),
        setUp: () {
          when(
            () => authenticationRepository.resetPassword(
              const PasswordResetRequestDto(
                phoneNumber: phoneNumber,
                newPassword: password,
              ),
            ),
          ).thenAnswer((_) async => left(const ApiNetworkError.timeout()));
        },
        act: (cubit) => cubit.submit(),
        expect:
            () => const [
              PasswordResetState(
                status: FormzSubmissionStatus.inProgress,
                phoneNumber: phoneNumber,
                passwordInput: PasswordInput.dirty(password),
                isPhoneNumberValid: true,
              ),
              PasswordResetState(
                status: FormzSubmissionStatus.failure,
                phoneNumber: phoneNumber,
                passwordInput: PasswordInput.dirty(password),
                isPhoneNumberValid: true,
                error: ApiNetworkError.timeout(),
              ),
            ],
      );
    });
  });
}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}
