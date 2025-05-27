part of 'password_reset_cubit.dart';

class PasswordResetState extends Equatable {
  final String? phoneNumber;
  final FormzSubmissionStatus status;
  final ApiNetworkError? error;
  final bool? isPhoneNumberValid;
  final PasswordInput passwordInput;

  const PasswordResetState({
    this.phoneNumber,
    this.status = FormzSubmissionStatus.initial,
    this.error,
    this.isPhoneNumberValid,
    this.passwordInput = const PasswordInput.pure(),
  });

  PasswordResetState updatePhoneNumber(String phoneNumber) {
    return PasswordResetState(
      phoneNumber: phoneNumber,
      error: error,
      isPhoneNumberValid: isPhoneNumberValid,
      passwordInput: passwordInput,
    );
  }

  PasswordResetState updatePassword(PasswordInput input) {
    return PasswordResetState(
      phoneNumber: phoneNumber,
      error: error,
      isPhoneNumberValid: isPhoneNumberValid,
      passwordInput: input,
    );
  }

  PasswordResetState updatePhoneNumberValidation({
    required bool isPhoneNumberValid,
  }) {
    return PasswordResetState(
      phoneNumber: phoneNumber,
      status: status,
      error: error,
      isPhoneNumberValid: isPhoneNumberValid,
      passwordInput: passwordInput,
    );
  }

  PasswordResetState validate() {
    return PasswordResetState(
      phoneNumber: phoneNumber,
      status: status,
      error: error,
      isPhoneNumberValid: isPhoneNumberValid,
      passwordInput: PasswordInput.dirty(passwordInput.value),
    );
  }

  PasswordResetState loading() {
    return PasswordResetState(
      status: FormzSubmissionStatus.inProgress,
      phoneNumber: phoneNumber,
      passwordInput: passwordInput,
      isPhoneNumberValid: isPhoneNumberValid,
    );
  }

  PasswordResetState failure(ApiNetworkError error) {
    return PasswordResetState(
      error: error,
      status: FormzSubmissionStatus.failure,
      phoneNumber: phoneNumber,
      passwordInput: passwordInput,
      isPhoneNumberValid: isPhoneNumberValid,
    );
  }

  PasswordResetState success() {
    return PasswordResetState(
      status: FormzSubmissionStatus.success,
      phoneNumber: phoneNumber,
      passwordInput: passwordInput,
      isPhoneNumberValid: isPhoneNumberValid,
    );
  }

  @override
  List<Object?> get props => [
    phoneNumber,
    status,
    error,
    isPhoneNumberValid,
    passwordInput,
  ];

  PasswordResetState copyWith({
    String? phoneNumber,
    FormzSubmissionStatus? status,
    ApiNetworkError? error,
    bool? isPhoneNumberValid,
    PasswordInput? passwordInput,
  }) {
    return PasswordResetState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      status: status ?? this.status,
      error: error ?? this.error,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      passwordInput: passwordInput ?? this.passwordInput,
    );
  }
}
