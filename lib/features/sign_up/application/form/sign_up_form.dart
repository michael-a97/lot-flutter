import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'name_input.dart';

part 'password_input.dart';

part 'confirm_password_input.dart';

class SignUpForm extends Equatable with FormzMixin {
  final NameInput firstName;
  final NameInput lastName;
  final PasswordInput passwordInput;
  final ConfirmPasswordInput confirmPasswordInput;

  const SignUpForm({
    this.firstName = const NameInput.pure(),
    this.lastName = const NameInput.pure(),
    this.passwordInput = const PasswordInput.pure(),
    this.confirmPasswordInput = const ConfirmPasswordInput.pure(),
  });

  @override
  List<FormzInput> get inputs => [
    firstName,
    lastName,
    passwordInput,
    confirmPasswordInput,
  ];

  @override
  List<Object> get props => inputs;

  SignUpForm validate() {
    return SignUpForm(
      firstName: NameInput.dirty(firstName.value),
      lastName: NameInput.dirty(lastName.value),
      passwordInput: PasswordInput.dirty(passwordInput.value),
      confirmPasswordInput: ConfirmPasswordInput.dirty(
        passwordInput.value ?? '',
        confirmPasswordInput.value,
      ),
    );
  }

  SignUpForm copyWith({
    NameInput? firstName,
    NameInput? lastName,
    PasswordInput? passwordInput,
    ConfirmPasswordInput? confirmPasswordInput,
  }) {
    return SignUpForm(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      passwordInput: passwordInput ?? this.passwordInput,
      confirmPasswordInput: confirmPasswordInput ?? this.confirmPasswordInput,
    );
  }
}
