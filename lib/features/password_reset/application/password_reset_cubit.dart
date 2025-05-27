import 'package:bloc/bloc.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';
import 'package:injectable/injectable.dart';

import '../../sign_up/application/form/sign_up_form.dart';

part 'password_reset_state.dart';

@Injectable()
class PasswordResetCubit extends Cubit<PasswordResetState> {
  final AuthenticationRepository authenticationRepository;

  PasswordResetCubit(this.authenticationRepository)
    : super(const PasswordResetState());

  void onPhoneNumberChanged(String value) {
    emit(state.updatePhoneNumber(value));
  }

  void onPhoneNumberValidated({required bool isValid}) {
    emit(state.updatePhoneNumberValidation(isPhoneNumberValid: isValid));
  }

  void onPasswordChanged(String value) {
    final passwordInput = PasswordInput.dirty(value);
    emit(state.updatePassword(passwordInput));
  }

  Future<void> submit() async {
    emit(state.validate());
    if ((state.isPhoneNumberValid ?? false) && state.passwordInput.isValid) {
      emit(state.loading());
      final response = await authenticationRepository.resetPassword(
        PasswordResetRequestDto(
          phoneNumber: state.phoneNumber!,
          newPassword: state.passwordInput.value!,
        ),
      );
      emit(response.fold(state.failure, (_) => state.success()));
    }
  }
}
