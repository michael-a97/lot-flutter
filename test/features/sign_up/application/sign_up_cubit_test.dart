import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:lot/features/sign_up/application/form/sign_up_form.dart';
import 'package:lot/features/sign_up/sign_up.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group('$SignUpCubit', () {
    late SignUpCubit signUpCubit;
    late AccountRepository accountRepository;

    setUp(() {
      accountRepository = MockAccountRepository();
      signUpCubit = SignUpCubit(accountRepository);
    });

    group('onFirstNameChanged', () {
      const name = 'John';
      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState] with updated first name',
        build: () => signUpCubit,
        act: (cubit) => cubit.onFirstNameChanged(name),
        expect:
            () => const [
              SignUpState(form: SignUpForm(firstName: NameInput.dirty(name))),
            ],
      );
    });

    group('onLastNameChanged', () {
      const name = 'John';
      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState] with updated last name',
        build: () => signUpCubit,
        act: (cubit) => cubit.onLastNameChanged(name),
        expect:
            () => const [
              SignUpState(form: SignUpForm(lastName: NameInput.dirty(name))),
            ],
      );
    });

    group('onPasswordChanged', () {
      const password = 'P@ssw0rd123';
      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState] with updated password',
        build: () => signUpCubit,
        act: (cubit) => cubit.onPasswordChanged(password),
        expect:
            () => const [
              SignUpState(
                form: SignUpForm(passwordInput: PasswordInput.dirty(password)),
              ),
            ],
      );
    });

    group('onConfirmPasswordChanged', () {
      const password = 'P@ssw0rd123';
      const confirmPassword = 'P@ssw0rd123';
      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState] with updated password',
        build: () => signUpCubit,
        seed:
            () => const SignUpState(
              form: SignUpForm(passwordInput: PasswordInput.dirty(password)),
            ),
        act: (cubit) => cubit.onConfirmPasswordChanged(confirmPassword),
        expect:
            () => const [
              SignUpState(
                form: SignUpForm(
                  passwordInput: PasswordInput.dirty(password),
                  confirmPasswordInput: ConfirmPasswordInput.dirty(
                    password,
                    confirmPassword,
                  ),
                ),
              ),
            ],
      );
    });

    group('onPhoneNumberChanged', () {
      const phoneNumber = '+251923001100';
      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState] with updated phone number',
        build: () => signUpCubit,
        act: (cubit) => cubit.onPhoneNumberChanged(phoneNumber),
        expect: () => const [SignUpState(phoneNumber: phoneNumber)],
      );
    });

    group('submit', () {
      const phoneNumber = '+251923001100';
      const firstName = 'John';
      const lastName = 'Doe';
      const password = 'P@ssw0rd123*';

      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState, SignUpState] with inProgress, success '
        'status when successful',
        build: () => signUpCubit,
        seed:
            () => const SignUpState(
              phoneNumber: phoneNumber,
              isPhoneNumberValid: true,
              form: SignUpForm(
                firstName: NameInput.dirty(firstName),
                lastName: NameInput.dirty(lastName),
                passwordInput: PasswordInput.dirty(password),
                confirmPasswordInput: ConfirmPasswordInput.dirty(
                  password,
                  password,
                ),
              ),
            ),
        setUp: () {
          when(
            () => accountRepository.signUp(
              const SignUpRequestDto(
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                password: password,
              ),
            ),
          ).thenAnswer(
            (_) async => right(
              const UserDto(
                id: 1,
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                role: Role.user,
              ),
            ),
          );
        },
        act: (cubit) => cubit.submit(),
        expect:
            () => const [
              SignUpState(
                phoneNumber: phoneNumber,
                form: SignUpForm(
                  firstName: NameInput.dirty(firstName),
                  lastName: NameInput.dirty(lastName),
                  passwordInput: PasswordInput.dirty(password),
                  confirmPasswordInput: ConfirmPasswordInput.dirty(
                    password,
                    password,
                  ),
                ),
                status: FormzSubmissionStatus.inProgress,
                isPhoneNumberValid: true,
              ),
              SignUpState(
                phoneNumber: phoneNumber,
                form: SignUpForm(
                  firstName: NameInput.dirty(firstName),
                  lastName: NameInput.dirty(lastName),
                  passwordInput: PasswordInput.dirty(password),
                  confirmPasswordInput: ConfirmPasswordInput.dirty(
                    password,
                    password,
                  ),
                ),
                status: FormzSubmissionStatus.success,
                isPhoneNumberValid: true,
              ),
            ],
      );

      blocTest<SignUpCubit, SignUpState>(
        'should emit [SignUpState, SignUpState] with inProgress, failure '
        'status when an error occurs',
        build: () => signUpCubit,
        seed:
            () => const SignUpState(
              phoneNumber: phoneNumber,
              form: SignUpForm(
                firstName: NameInput.dirty(firstName),
                lastName: NameInput.dirty(lastName),
                passwordInput: PasswordInput.dirty(password),
                confirmPasswordInput: ConfirmPasswordInput.dirty(
                  password,
                  password,
                ),
              ),
              isPhoneNumberValid: true,
            ),
        setUp: () {
          when(
            () => accountRepository.signUp(
              const SignUpRequestDto(
                phoneNumber: phoneNumber,
                firstName: firstName,
                lastName: lastName,
                password: password,
              ),
            ),
          ).thenAnswer((_) async => left(const ApiNetworkError.timeout()));
        },
        act: (cubit) => cubit.submit(),
        expect:
            () => const [
              SignUpState(
                phoneNumber: phoneNumber,
                form: SignUpForm(
                  firstName: NameInput.dirty(firstName),
                  lastName: NameInput.dirty(lastName),
                  passwordInput: PasswordInput.dirty(password),
                  confirmPasswordInput: ConfirmPasswordInput.dirty(
                    password,
                    password,
                  ),
                ),
                status: FormzSubmissionStatus.inProgress,
                isPhoneNumberValid: true,
              ),
              SignUpState(
                phoneNumber: phoneNumber,
                form: SignUpForm(
                  firstName: NameInput.dirty(firstName),
                  lastName: NameInput.dirty(lastName),
                  passwordInput: PasswordInput.dirty(password),
                  confirmPasswordInput: ConfirmPasswordInput.dirty(
                    password,
                    password,
                  ),
                ),
                status: FormzSubmissionStatus.failure,
                error: ApiNetworkError.timeout(),
                isPhoneNumberValid: true,
              ),
            ],
      );
    });
  });
}

class MockAccountRepository extends Mock implements AccountRepository {}
