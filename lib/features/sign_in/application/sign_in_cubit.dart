import 'package:bloc/bloc.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import 'model/sign_in_password_input.dart';

part 'sign_in_state.dart';

@Injectable()
class SignInCubit extends Cubit<SignInState> {
  final AuthenticationRepository _authenticationRepository;

  SignInCubit(this._authenticationRepository) : super(const SignInState());

  void onPhoneNumberChanged(String value) {
    emit(state.edit(phoneNumber: value));
  }

  void onPhoneNumberValidated({required bool isValid}) {
    emit(state.edit(phoneNumberValid: isValid));
  }

  void onPasswordChanged(String value) {
    final passwordInput = SignInPasswordInput.dirty(value);
    emit(state.edit(passwordInput: passwordInput));
  }

  Future<void> submit() async {
    if (state.phoneNumberValid && state.passwordInput.isValid) {
      emit(state.loading());

      final response = await _authenticationRepository.signIn(
        SignInFormDto(
          phoneNumber: state.phoneNumber!,
          password: state.passwordInput.value!,
        ),
      );

      emit(response.fold(state.failure, (_) => state.success()));
    }
  }
}
