part of 'sign_up_cubit.dart';

class SignUpState extends Equatable {
  final SignUpForm form;
  final String? phoneNumber;
  final bool isPhoneNumberValid;
  final FormzSubmissionStatus status;
  final ApiNetworkError? error;

  const SignUpState({
    this.form = const SignUpForm(),
    this.phoneNumber,
    this.status = FormzSubmissionStatus.initial,
    this.error,
    this.isPhoneNumberValid = false,
  });

  SignUpState loading() {
    return SignUpState(
      phoneNumber: phoneNumber,
      form: form,
      status: FormzSubmissionStatus.inProgress,
      isPhoneNumberValid: isPhoneNumberValid,
    );
  }

  SignUpState success() {
    return SignUpState(
      phoneNumber: phoneNumber,
      form: form,
      status: FormzSubmissionStatus.success,
      isPhoneNumberValid: isPhoneNumberValid,
    );
  }

  SignUpState failure(ApiNetworkError error) {
    return SignUpState(
      phoneNumber: phoneNumber,
      form: form,
      status: FormzSubmissionStatus.failure,
      error: error,
      isPhoneNumberValid: isPhoneNumberValid,
    );
  }

  SignUpState copyWith({
    SignUpForm? form,
    String? phoneNumber,
    bool? isPhoneNumberValid,
    FormzSubmissionStatus? status,
    ApiNetworkError? error,
  }) {
    return SignUpState(
      form: form ?? this.form,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      isPhoneNumberValid: isPhoneNumberValid ?? this.isPhoneNumberValid,
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  List<Object?> get props => [
    form,
    phoneNumber,
    isPhoneNumberValid,
    status,
    error,
  ];
}
