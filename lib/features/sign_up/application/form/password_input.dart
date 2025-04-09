part of 'sign_up_form.dart';

class PasswordInput extends FormzInput<String?, PasswordInputValidationError> {
  const PasswordInput.pure([super.value]) : super.pure();

  const PasswordInput.dirty([super.value]) : super.dirty();

  @override
  PasswordInputValidationError? validator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return PasswordInputValidationError.empty;
    } else if (value.length < 8) {
      return PasswordInputValidationError.tooShort;
    } else if (!RegExp(
      r'^(?=.*[A-Z])(?=.*[a-z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{8,}$',
    ).hasMatch(value)) {
      return PasswordInputValidationError.weak;
    }
    return null;
  }
}

enum PasswordInputValidationError { empty, tooShort, weak }
