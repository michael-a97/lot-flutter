part of 'sign_up_form.dart';

class ConfirmPasswordInput extends FormzInput<String, ConfirmPasswordError> {
  final String password;

  const ConfirmPasswordInput.pure([this.password = '', super.value = ''])
    : super.pure();

  const ConfirmPasswordInput.dirty(this.password, super.value) : super.dirty();

  @override
  ConfirmPasswordError? validator(String value) {
    if (value.isEmpty) {
      return ConfirmPasswordError.empty;
    } else if (value != password) {
      return ConfirmPasswordError.doNotMatch;
    }
    return null;
  }
}

enum ConfirmPasswordError { empty, doNotMatch }
