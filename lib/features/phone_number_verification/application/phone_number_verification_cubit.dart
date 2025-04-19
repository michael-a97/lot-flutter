import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:data/data.dart';
import 'package:dtos/dtos.dart';
import 'package:equatable/equatable.dart';
import 'package:injectable/injectable.dart';

part 'phone_number_authentication_state.dart';

@injectable
class PhoneNumberVerificationCubit extends Cubit<PhoneNumberVerificationState> {
  final AuthenticationRepository _authenticationRepository;
  StreamSubscription? _streamSubscription;

  PhoneNumberVerificationCubit(this._authenticationRepository)
    : super(const PhoneNumberVerificationState());

  @override
  Future<void> close() {
    _streamSubscription?.cancel();
    return super.close();
  }

  Future<void> resetForResend() async {
    emit(state.resetForResend());
  }

  Future<void> requestOtpVerification(String phoneNumber) async {
    emit(state.loading());
    await _streamSubscription?.cancel();
    _streamSubscription = _authenticationRepository
        .requestPhoneVerification(phoneNumber)
        .map(_mapStatusToState)
        .listen(emit);
  }

  Future<void> resendOtpVerification() async {
    if (state.resendToken != null && state.phoneNumber != null) {
      emit(state.loading());
      await _streamSubscription?.cancel();
      _streamSubscription = _authenticationRepository
          .requestPhoneVerification(state.phoneNumber!, state.resendToken)
          .map(_mapStatusToState)
          .listen(emit);
    }
  }

  Future<void> verifyOtp(String otp) async {
    final verificationId = state.verificationId;
    if (verificationId != null && otp.length == 6) {
      emit(state.loading());
      final response = await _authenticationRepository.verifyPhoneOtp(
        otp,
        verificationId,
      );
      emit(response.fold(state.error, (_) => state.completed()));
    }
  }

  PhoneNumberVerificationState _mapStatusToState(
    PhoneVerificationStatus status,
  ) {
    if (status is StatusOtpCodeSent) {
      return state.otpCodeSent(status);
    } else if (status is StatusOtpVerificationComplete) {
      return state.completed();
    } else if (status is StatusOtpVerificationFailed) {
      return state.error(status);
    } else {
      const defaultError = StatusOtpVerificationFailed(
        OtpVerificationError.unknown,
      );
      return state.error(defaultError);
    }
  }
}
