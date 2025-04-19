import 'package:bloc/bloc.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import 'form/sign_up_form.dart';

part 'sign_up_state.dart';

@injectable
class SignUpCubit extends Cubit<SignUpState> {
  final AccountRepository _accountRepository;

  SignUpCubit(this._accountRepository) : super(const SignUpState());

  void onFirstNameChanged(String value) {
    final form = state.form.copyWith(firstName: NameInput.dirty(value));
    _onFormEdited(form);
  }

  void onLastNameChanged(String value) {
    final form = state.form.copyWith(lastName: NameInput.dirty(value));
    _onFormEdited(form);
  }

  void onPasswordChanged(String value) {
    final form = state.form.copyWith(passwordInput: PasswordInput.dirty(value));
    _onFormEdited(form);
  }

  void onConfirmPasswordChanged(String value) {
    final form = state.form.copyWith(
      confirmPasswordInput: ConfirmPasswordInput.dirty(
        state.form.passwordInput.value!,
        value,
      ),
    );
    _onFormEdited(form);
  }

  void onPhoneNumberChanged(String value) {
    emit(state.copyWith(phoneNumber: value));
  }

  void _onFormEdited(SignUpForm form) {
    emit(state.copyWith(form: form));
  }

  void onPhoneNumberValidated({required bool isValid}) {
    emit(state.copyWith(isPhoneNumberValid: isValid));
  }

  Future<void> submit() async {
    final form = state.form.validate();
    _onFormEdited(form);
    if (!form.isValid) {
      return;
    }
    emit(state.loading());
    final request = SignUpRequestDto(
      phoneNumber: state.phoneNumber ?? '',
      firstName: state.form.firstName.value!,
      lastName: state.form.lastName.value!,
      password: state.form.passwordInput.value!,
    );
    final response = await _accountRepository.signUp(request);
    emit(response.fold(state.failure, (_) => state.success()));
  }
}
