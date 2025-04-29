import 'package:formz/formz.dart';

class SignInPasswordInput extends FormzInput<String?, SignInPasswordError> {
  const SignInPasswordInput.dirty(super.value) : super.dirty();

  const SignInPasswordInput.pure([super.value]) : super.pure();

  @override
  SignInPasswordError? validator(String? value) {
    if (value == null || value.isEmpty) {
      return SignInPasswordError.empty;
    }
    return null;
  }
}

enum SignInPasswordError { empty, invalid }
