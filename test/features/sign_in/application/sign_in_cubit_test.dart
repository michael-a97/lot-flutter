import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:lot/features/sign_in/sign_in.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('$SignInCubit', () {
    late AuthenticationRepository authenticationRepository;
    late SignInCubit signInCubit;

    setUp(() {
      authenticationRepository = MockAuthenticationRepository();
      signInCubit = SignInCubit(authenticationRepository);
    });

    group('onPhoneNumberChanged', () {
      const phoneNumber = '+251923001100';
      blocTest(
        'should emit a SignInState with updated phoneNumber ',
        build: () => signInCubit,
        act: (cubit) => cubit.onPhoneNumberChanged(phoneNumber),
        expect: () => const [SignInState(phoneNumber: phoneNumber)],
      );
    });

    group('onPhoneNumberValidated', () {
      const isValid = false;
      blocTest(
        'should emit a SignInState with updated phoneNumberValid value ',
        build: () => signInCubit,
        act: (cubit) => cubit.onPhoneNumberValidated(isValid: isValid),
        expect: () => const [SignInState(phoneNumberValid: isValid)],
      );
    });

    group('onPasswordChanged', () {
      const password = 'P@ssw0rd';
      blocTest(
        'should emit a SignInState with updated password ',
        build: () => signInCubit,
        act: (cubit) => cubit.onPasswordChanged(password),
        expect:
            () => const [
              SignInState(passwordInput: SignInPasswordInput.dirty(password)),
            ],
      );
    });

    group('submit', () {
      const password = 'P@ssw0rd';
      const phoneNumber = '+251923001100';
      blocTest(
        'should emit a [SignInState, SignInState] with inProgress and success '
        'statuses when successful',
        build: () => signInCubit,
        setUp: () {
          when(
            () => authenticationRepository.signIn(
              const SignInFormDto(phoneNumber: phoneNumber, password: password),
            ),
          ).thenAnswer((_) async {
            return right(
              SignInResponseDto(
                accessToken: '',
                refreshToken: '',
                user: _FakeUserDto(),
              ),
            );
          });
        },
        seed:
            () => const SignInState(
              passwordInput: SignInPasswordInput.dirty(password),
              phoneNumber: phoneNumber,
            ),
        act: (cubit) => cubit.submit(),
        expect:
            () => const [
              SignInState(
                status: FormzSubmissionStatus.inProgress,
                passwordInput: SignInPasswordInput.dirty(password),
                phoneNumber: phoneNumber,
              ),
              SignInState(
                status: FormzSubmissionStatus.success,
                passwordInput: SignInPasswordInput.dirty(password),
                phoneNumber: phoneNumber,
              ),
            ],
      );
      blocTest(
        'should emit a [SignInState, SignInState] with inProgress and failure '
        'statuses when unsuccessful',
        build: () => signInCubit,
        setUp: () {
          when(
            () => authenticationRepository.signIn(
              const SignInFormDto(phoneNumber: phoneNumber, password: password),
            ),
          ).thenAnswer((_) async => left(const ApiNetworkError.timeout()));
        },
        seed:
            () => const SignInState(
              passwordInput: SignInPasswordInput.dirty(password),
              phoneNumber: phoneNumber,
            ),
        act: (cubit) => cubit.submit(),
        expect:
            () => const [
              SignInState(
                status: FormzSubmissionStatus.inProgress,
                passwordInput: SignInPasswordInput.dirty(password),
                phoneNumber: phoneNumber,
              ),
              SignInState(
                status: FormzSubmissionStatus.failure,
                passwordInput: SignInPasswordInput.dirty(password),
                phoneNumber: phoneNumber,
                error: ApiNetworkError.timeout(),
              ),
            ],
      );
    });
  });
}

class MockAuthenticationRepository extends Mock
    implements AuthenticationRepository {}

class _FakeUserDto extends Fake implements UserDto {}
