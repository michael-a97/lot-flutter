part of 'sign_up_form.dart';

class NameInput extends FormzInput<String?, NameInputValidationError> {
  const NameInput.pure([super.value]) : super.pure();

  const NameInput.dirty([super.value]) : super.dirty();

  @override
  NameInputValidationError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return NameInputValidationError.empty;
    } else if (value.length < 3) {
      return NameInputValidationError.tooShort;
    }
    return null;
  }
}

enum NameInputValidationError { empty, tooShort }
