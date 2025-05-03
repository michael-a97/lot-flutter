part of 'sign_in_cubit.dart';

class SignInState extends Equatable {
  final SignInPasswordInput passwordInput;
  final String? phoneNumber;
  final FormzSubmissionStatus status;
  final ApiNetworkError? error;
  final bool phoneNumberValid;

  const SignInState({
    this.passwordInput = const SignInPasswordInput.pure(),
    this.phoneNumber,
    this.status = FormzSubmissionStatus.initial,
    this.error,
    this.phoneNumberValid = true,
  });

  SignInState edit({
    SignInPasswordInput? passwordInput,
    String? phoneNumber,
    bool? phoneNumberValid,
  }) {
    return SignInState(
      passwordInput: passwordInput ?? this.passwordInput,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      phoneNumberValid: phoneNumberValid ?? this.phoneNumberValid,
    );
  }

  SignInState loading() {
    return SignInState(
      passwordInput: passwordInput,
      phoneNumber: phoneNumber,
      status: FormzSubmissionStatus.inProgress,
    );
  }

  SignInState success() {
    return SignInState(
      passwordInput: passwordInput,
      phoneNumber: phoneNumber,
      status: FormzSubmissionStatus.success,
    );
  }

  SignInState failure(ApiNetworkError error) {
    return SignInState(
      passwordInput: passwordInput,
      phoneNumber: phoneNumber,
      status: FormzSubmissionStatus.failure,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    passwordInput,
    phoneNumber,
    status,
    error,
    phoneNumberValid,
  ];
}
